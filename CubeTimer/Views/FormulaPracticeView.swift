import SwiftUI

struct FormulaPracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PracticeViewModel()
    @State private var showAlgorithm = false
    @State private var selectedCategory: CFOPStage? = nil
    @State private var quizMode = false
    @State private var quizOptions: [Formula] = []
    @State private var selectedAnswer: Formula?
    @State private var showResult = false
    @State private var isCorrect = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部：模式切换
                VStack(spacing: 12) {
                    // 模式切换
                    Picker("", selection: $quizMode) {
                        Text("学习模式").tag(false)
                        Text("答题模式").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // 分类筛选
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
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
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.1))

                // 主内容区
                if let currentFormula = viewModel.currentFormula {
                    if quizMode {
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
                    } else {
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
            .navigationTitle("公式练习")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .onChange(of: quizMode) { oldValue, newValue in
                if newValue && !oldValue {
                    generateQuiz()
                }
            }
        }
    }
        VStack(spacing: 0) {
            // 顶部：模式切换
            VStack(spacing: 12) {
                // 模式切换
                Picker("", selection: $quizMode) {
                    Text("学习模式").tag(false)
                    Text("答题模式").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // 分类筛选
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
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
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            .background(Color.gray.opacity(0.1))

            // 主内容区
            if let currentFormula = viewModel.currentFormula {
                if quizMode {
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
                } else {
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
        .onChange(of: quizMode) { oldValue, newValue in
            if newValue && !oldValue {
                generateQuiz()
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
        if quizMode {
            generateQuiz()
        }
    }
}

// 学习模式视图
struct StudyModeView: View {
    let formula: Formula
    let showAlgorithm: Bool
    let viewModel: PracticeViewModel
    let onToggleAlgorithm: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 公式图片
            if let imageName = formula.imageName {
                LocalAsyncImage(imageName: imageName) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .clipped()
                    case .failure(_):
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }

            // 公式名称
            Text(formula.name)
                .font(.title2)
                .fontWeight(.bold)

            // 公式描述
            Text(formula.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // 算法显示/隐藏
            VStack(spacing: 12) {
                if showAlgorithm {
                    Text(formula.algorithm)
                        .font(.system(.title2, design: .monospaced))
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        .transition(.opacity)
                } else {
                    Text("点击查看算法")
                        .font(.body)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            onToggleAlgorithm()
                        }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showAlgorithm)

            // 统计信息
            HStack(spacing: 20) {
                StatItem(label: "练习次数", value: "\(viewModel.getPracticeCount(for: formula))")
                StatItem(label: "掌握状态", value: viewModel.isMastered(formula) ? "已掌握" : "练习中")
            }

            Spacer()

            // 操作按钮
            VStack(spacing: 12) {
                // 显示/隐藏算法按钮
                Button(action: onToggleAlgorithm) {
                    Text(showAlgorithm ? "隐藏算法" : "显示算法")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }

                // 标记掌握按钮
                Button(action: {
                    viewModel.toggleMastered(formula)
                }) {
                    HStack {
                        Image(systemName: viewModel.isMastered(formula) ? "checkmark.circle.fill" : "circle")
                        Text(viewModel.isMastered(formula) ? "已掌握" : "标记为已掌握")
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isMastered(formula) ? Color.green : Color.gray)
                    .cornerRadius(12)
                }

                // 下一个公式按钮
                Button(action: onNext) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("下一个公式")
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }

    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 200)
            .overlay(
                VStack {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("暂无图片")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            )
    }
}

// 答题模式视图
struct QuizModeView: View {
    let formula: Formula
    let options: [Formula]
    @Binding var selectedAnswer: Formula?
    let showResult: Bool
    let isCorrect: Bool
    let onAnswer: (Formula) -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 提示文字
            VStack(spacing: 8) {
                Text("请选择正确的算法")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("查看上面的魔方状态，选择对应的公式")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            // 公式图片
            if let imageName = formula.imageName {
                LocalAsyncImage(imageName: imageName) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 180)
                            .clipped()
                    case .failure(_):
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }

            // 答案选项
            VStack(spacing: 10) {
                ForEach(options) { option in
                    AnswerButton(
                        formula: option,
                        isSelected: selectedAnswer?.id == option.id,
                        showResult: showResult,
                        isCorrect: option.id == formula.id
                    ) {
                        if !showResult {
                            onAnswer(option)
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // 结果反馈和下一步按钮
            if showResult {
                VStack(spacing: 12) {
                    // 结果提示
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title)
                        Text(isCorrect ? "回答正确！" : "回答错误")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
                    .background((isCorrect ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(12)

                    // 正确答案（如果答错了）
                    if !isCorrect {
                        VStack(spacing: 4) {
                            Text("正确答案：")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formula.algorithm)
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }

                    // 下一题按钮
                    Button(action: onNext) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("下一题")
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
    }

    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 180)
            .overlay(
                VStack {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("暂无图片")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            )
    }
}

// 答案按钮
struct AnswerButton: View {
    let formula: Formula
    let isSelected: Bool
    let showResult: Bool
    let isCorrect: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formula.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    Text(formula.algorithm)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.blue)
                }

                Spacer()

                if showResult {
                    if isSelected {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .disabled(showResult)
    }

    private var backgroundColor: Color {
        if showResult {
            if isSelected {
                return isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2)
            } else if isCorrect {
                return Color.green.opacity(0.1)
            }
        }
        return isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
    }
}

// 分类按钮
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// 统计项
struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// 异步加载本地图片
struct LocalAsyncImage: View {
    let imageName: String
    let content: (LocalAsyncImagePhase) -> AnyView

    init<Content>(imageName: String, @ViewBuilder content: @escaping (LocalAsyncImagePhase) -> Content) where Content: View {
        self.imageName = imageName
        self.content = { phase in AnyView(content(phase)) }
    }

    var body: some View {
        if let image = UIImage(named: imageName) {
            content(.success(Image(uiImage: image)))
        } else {
            content(.empty)
        }
    }

    enum LocalAsyncImagePhase {
        case empty
        case success(Image)
        case failure(Error)
    }
}

#Preview {
    FormulaPracticeView()
}
