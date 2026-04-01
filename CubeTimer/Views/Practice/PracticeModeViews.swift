import SwiftUI

// 学习模式视图
struct StudyModeView: View {
    let formula: Formula
    let showAlgorithm: Bool
    let viewModel: PracticeViewModel
    let onToggleAlgorithm: () -> Void
    let onNext: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 公式图片
                if let imageName = formula.imageName {
                    LocalAsyncImage(imageName: imageName) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 200, height: 200)
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
                Text(formula.name).font(.title2).fontWeight(.bold)

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
                            .onTapGesture { onToggleAlgorithm() }
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
                    Button(action: onToggleAlgorithm) {
                        Text(showAlgorithm ? "隐藏算法" : "显示算法")
                            .font(.title3).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                            .background(Color.blue).cornerRadius(12)
                    }

                    Button(action: { viewModel.toggleMastered(formula) }) {
                        HStack {
                            Image(systemName: viewModel.isMastered(formula) ? "checkmark.circle.fill" : "circle")
                            Text(viewModel.isMastered(formula) ? "已掌握" : "标记为已掌握")
                        }
                        .font(.title3).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                        .background(viewModel.isMastered(formula) ? Color.green : Color.gray).cornerRadius(12)
                    }

                    Button(action: onNext) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("下一个公式")
                        }
                        .font(.title3).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                        .background(Color.orange).cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // 增加底部间距，离屏幕下边框保持距离
            }
        }
    }

    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 200)
            .overlay(
                VStack {
                    Image(systemName: "cube.fill").font(.system(size: 40)).foregroundColor(.gray)
                    Text("暂无图片").font(.caption).foregroundColor(.secondary)
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
        ScrollView {
            VStack(spacing: 20) {
                // 提示文字
                VStack(spacing: 8) {
                    Text("请选择正确的算法").font(.title2).fontWeight(.bold)
                    Text("查看上面的魔方状态，选择对应的公式").font(.body).foregroundColor(.secondary)
                }

                // 公式图片
                if let imageName = formula.imageName {
                    LocalAsyncImage(imageName: imageName) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 200, height: 200)
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fit).frame(height: 180).clipped()
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
                            if !showResult { onAnswer(option) }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // 结果反馈
                if showResult {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill").font(.title)
                            Text(isCorrect ? "回答正确！" : "回答错误").font(.title3).fontWeight(.semibold)
                        }
                        .foregroundColor(isCorrect ? .green : .red).padding()
                        .background((isCorrect ? Color.green : Color.red).opacity(0.1)).cornerRadius(12)

                        if !isCorrect {
                            VStack(spacing: 4) {
                                Text("正确答案：").font(.caption).foregroundColor(.secondary)
                                Text(formula.algorithm).font(.system(.body, design: .monospaced)).fontWeight(.semibold).foregroundColor(.blue)
                            }
                            .padding().background(Color.blue.opacity(0.1)).cornerRadius(12)
                        }

                        Button(action: onNext) {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("下一题")
                            }
                            .font(.title3).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                            .background(Color.blue).cornerRadius(12)
                        }
                        .padding()
                    }
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
                    Image(systemName: "cube.fill").font(.system(size: 40)).foregroundColor(.gray)
                    Text("暂无图片").font(.caption).foregroundColor(.secondary)
                }
            )
    }
}

// 交互模式视图
struct InteractiveModeView: View {
    let formula: Formula
    @Binding var userMoves: [String]
    let showResult: Bool
    let isCorrect: Bool
    let showSuccessFeedback: Bool
    let onMove: (String) -> Void
    let onSubmit: () -> Void
    let onReset: () -> Void
    let onNext: () -> Void

    private let moves = ["R", "L", "U", "D", "F", "B"]
    private let modifiers = ["", "'", "2"]

    var body: some View {
        VStack(spacing: 0) {
            // 提示文字
            VStack(spacing: 4) {
                Text("按顺序完成这个公式").font(.headline).fontWeight(.bold)
                Text("查看上面的魔方状态，点击按钮完成操作").font(.caption).foregroundColor(.secondary)
            }
            .padding(.top, 8)
            .padding(.bottom, 4)

            // 公式图片
            if let imageName = formula.imageName {
                LocalAsyncImage(imageName: imageName) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 120, height: 120)
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit).frame(height: 120).clipped()
                    case .failure(_):
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }

            // 用户输入的操作序列
            VStack(spacing: 6) {
                HStack {
                    Text("你的操作").font(.caption).fontWeight(.semibold).foregroundColor(.secondary)
                    Spacer()
                    // 删除最后一步按钮（始终占据空间，避免跳动）
                    Button(action: {
                        if !userMoves.isEmpty {
                            userMoves.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.left")
                            .font(.caption)
                            .foregroundColor(userMoves.isEmpty ? Color.clear : .red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .disabled(userMoves.isEmpty)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(userMoves.enumerated()), id: \.offset) { _, move in
                            Text(move).font(.caption).fontWeight(.semibold).monospaced()
                                .foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4)
                                .background(userMoves.isEmpty ? Color.gray : Color.blue).cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .frame(height: 28)
            }
            .frame(height: 52) // 固定整个区域高度，防止跳动
            .padding(.horizontal, 12)
            .padding(.bottom, 8)

            // 操作按钮区域
            VStack(spacing: 8) {
                // 主要操作按钮
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(moves, id: \.self) { move in MoveButton(move: move) { onMove(move) } }
                }

                // 修饰按钮
                HStack(spacing: 8) {
                    ForEach(modifiers, id: \.self) { modifier in
                        Button(action: {
                            if !userMoves.isEmpty {
                                let lastMove = userMoves.removeLast()
                                let modifiedMove = modifier.isEmpty ? lastMove : lastMove + modifier
                                onMove(modifiedMove)
                            }
                        }) {
                            Text(modifier.isEmpty ? "无修饰" : modifier).font(.caption).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding(.vertical, 8).background(Color.orange).cornerRadius(6)
                        }
                        .disabled(userMoves.isEmpty || showResult)
                    }
                }
            }
            .padding(.horizontal, 12)

            Spacer()

            // 底部按钮
            VStack(spacing: 8) {
                if showResult {
                    // 结果显示
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill").font(.title3)
                        Text(isCorrect ? "回答正确！" : "回答错误").font(.subheadline).fontWeight(.semibold)
                    }
                    .foregroundColor(isCorrect ? .green : .red).padding(.vertical, 6).padding(.horizontal, 12)
                    .background((isCorrect ? Color.green : Color.red).opacity(0.1)).cornerRadius(8)

                    if !isCorrect {
                        VStack(spacing: 2) {
                            Text("正确答案：").font(.caption2).foregroundColor(.secondary)
                            Text(formula.algorithm).font(.caption).fontWeight(.semibold).monospaced().foregroundColor(.blue)
                        }
                        .padding(.vertical, 4).padding(.horizontal, 8).background(Color.blue.opacity(0.1)).cornerRadius(6)
                    }

                    Button(action: onNext) {
                        HStack { Image(systemName: "arrow.right.circle.fill"); Text("下一题") }
                            .font(.body).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Color.blue).cornerRadius(10)
                    }
                } else {
                    // 跳过、提交按钮
                    HStack(spacing: 8) {
                        // 跳过按钮
                        Button(action: onNext) {
                            HStack {
                                Image(systemName: "arrow.right.circle")
                                Text("跳过")
                            }
                            .font(.body).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Color.gray.opacity(0.5)).cornerRadius(10)
                        }

                        // 提交按钮
                        Button(action: onSubmit) {
                            HStack {
                                Image(systemName: "checkmark.square.fill")
                                Text("提交")
                            }
                            .font(.body).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(userMoves.isEmpty ? Color.gray : Color.green).cornerRadius(10)
                        }
                        .disabled(userMoves.isEmpty)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }

    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)).frame(height: 120)
            .overlay(VStack(spacing: 4) {
                Image(systemName: "cube.fill").font(.system(size: 24)).foregroundColor(.gray)
                Text("暂无图片").font(.caption2).foregroundColor(.secondary)
            })
    }
}
