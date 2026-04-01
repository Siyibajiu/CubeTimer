import SwiftUI

struct FormulaPracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PracticeViewModel()
    @State private var showAlgorithm = false
    @State private var selectedCategory: CFOPStage? = nil
    @State private var practiceMode: PracticeMode = .study
    @State private var quizOptions: [Formula] = []
    @State private var selectedAnswer: Formula?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var userMoves: [String] = []
    @State private var showSuccessFeedback = false

    enum PracticeMode {
        case study
        case quiz
        case interactive
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 模式切换
                VStack(spacing: 16) {
                    // 模式切换
                    Picker("Mode", selection: $practiceMode) {
                        Text("学习").tag(PracticeMode.study)
                        Text("答题").tag(PracticeMode.quiz)
                        Text("交互").tag(PracticeMode.interactive)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // 分类筛选
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryButton(title: "全部", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                                viewModel.loadFormulas(category: nil)
                                resetQuiz()
                            }

                            ForEach(CFOPStage.allCases, id: \.self) { stage in
                                CategoryButton(title: stage.rawValue, isSelected: selectedCategory == stage) {
                                    selectedCategory = stage
                                    viewModel.loadFormulas(category: stage)
                                    resetQuiz()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color.gray.opacity(0.1))

                // 主内容区
                if let currentFormula = viewModel.currentFormula {
                    switch practiceMode {
                    case .study:
                        // 学习模式
                        StudyModeView(
                            formula: currentFormula,
                            showAlgorithm: showAlgorithm,
                            viewModel: viewModel,
                            onToggleAlgorithm: {
                                withAnimation {
                                    showAlgorithm.toggle()
                                }
                            },
                            onNext: {
                                withAnimation {
                                    showAlgorithm = false
                                    viewModel.nextFormula()
                                }
                            }
                        )
                    case .quiz:
                        // 答题模式
                        QuizModeView(
                            formula: currentFormula,
                            options: quizOptions,
                            selectedAnswer: $selectedAnswer,
                            showResult: showResult,
                            isCorrect: isCorrect,
                            onAnswer: { answer in
                                checkAnswer(answer, correct: currentFormula)
                            },
                            onNext: {
                                nextQuiz()
                            }
                        )
                    case .interactive:
                        // 交互模式
                        InteractiveModeView(
                            formula: currentFormula,
                            userMoves: $userMoves,
                            showResult: showResult,
                            isCorrect: isCorrect,
                            showSuccessFeedback: showSuccessFeedback,
                            onMove: { move in
                                addMove(move)
                            },
                            onSubmit: {
                                submitAnswer(correct: currentFormula.algorithm)
                            },
                            onReset: {
                                resetInteractive()
                            },
                            onNext: {
                                nextInteractive()
                            }
                        )
                    }
                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("没有可练习的公式")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .onChange(of: practiceMode) { oldValue, newValue in
                if newValue != oldValue {
                    resetAllModes()
                    if newValue == .quiz {
                        generateQuiz()
                    }
                }
            }
        }
    }

    private func generateQuiz() {
        guard let current = viewModel.currentFormula else { return }

        let allFormulas = CompleteFormulaData.shared.getAllFormulas()
        let sameCategory = allFormulas.filter { $0.category == current.category && $0.id != current.id }

        // 随机选择3个干扰项
        var options = Array(sameCategory.shuffled().prefix(3))
        options.append(current)
        quizOptions = options.shuffled()
        selectedAnswer = nil
        showResult = false
    }

    private func checkAnswer(_ answer: Formula, correct: Formula) {
        selectedAnswer = answer
        isCorrect = answer.id == correct.id
        showResult = true

        // 记录练习
        viewModel.nextFormula()
    }

    private func nextQuiz() {
        selectedAnswer = nil
        showResult = false
        generateQuiz()
    }

    private func resetQuiz() {
        selectedAnswer = nil
        showResult = false
        if practiceMode == .quiz {
            generateQuiz()
        }
    }

    private func addMove(_ move: String) {
        userMoves.append(move)
    }

    private func submitAnswer(correct: String) {
        let userAlgorithm = userMoves.joined(separator: " ")
        showResult = true
        isCorrect = userAlgorithm == correct
        if isCorrect {
            showSuccessFeedback = true
        }
        // 不在这里调用 nextFormula，等用户点击"下一题"时再调用
    }

    private func resetInteractive() {
        userMoves = []
        showResult = false
        isCorrect = false
        showSuccessFeedback = false
    }

    private func nextInteractive() {
        resetInteractive()
        // 跳过当前题目，进入下一题
        viewModel.nextFormula()
    }

    private func resetAllModes() {
        selectedAnswer = nil
        showResult = false
        isCorrect = false
        userMoves = []
        showSuccessFeedback = false
    }
}

#Preview {
    FormulaPracticeView()
}
