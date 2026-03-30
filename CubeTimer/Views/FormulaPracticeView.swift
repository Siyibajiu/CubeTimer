import SwiftUI

struct FormulaPracticeView: View {
    @StateObject private var viewModel = PracticeViewModel()
    @State private var showAlgorithm = false
    @State private var selectedCategory: CFOPStage? = nil

    var body: some View {
        VStack(spacing: 0) {
            // 顶部：分类筛选
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    CategoryButton(title: "全部", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                        viewModel.loadFormulas(category: nil)
                    }

                    ForEach(CFOPStage.allCases, id: \.self) { stage in
                        CategoryButton(title: stage.rawValue, isSelected: selectedCategory == stage) {
                            selectedCategory = stage
                            viewModel.loadFormulas(category: stage)
                        }
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))

            // 主内容区
            if let currentFormula = viewModel.currentFormula {
                VStack(spacing: 20) {
                    Spacer()

                    // 公式图片
                    if let imageName = currentFormula.imageName {
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
                    Text(currentFormula.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    // 公式描述
                    Text(currentFormula.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // 算法显示/隐藏
                    VStack(spacing: 12) {
                        if showAlgorithm {
                            Text(currentFormula.algorithm)
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
                                    withAnimation {
                                        showAlgorithm.toggle()
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showAlgorithm)

                    // 统计信息
                    HStack(spacing: 20) {
                        StatItem(label: "练习次数", value: "\(viewModel.getPracticeCount(for: currentFormula))")
                        StatItem(label: "掌握状态", value: viewModel.isMastered(currentFormula) ? "已掌握" : "练习中")
                    }

                    Spacer()

                    // 操作按钮
                    VStack(spacing: 12) {
                        // 显示/隐藏算法按钮
                        Button(action: {
                            withAnimation {
                                showAlgorithm.toggle()
                            }
                        }) {
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
                            viewModel.toggleMastered(currentFormula)
                        }) {
                            HStack {
                                Image(systemName: viewModel.isMastered(currentFormula) ? "checkmark.circle.fill" : "circle")
                                Text(viewModel.isMastered(currentFormula) ? "已掌握" : "标记为已掌握")
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isMastered(currentFormula) ? Color.green : Color.gray)
                            .cornerRadius(12)
                        }

                        // 下一个公式按钮
                        Button(action: {
                            withAnimation {
                                showAlgorithm = false
                                viewModel.nextFormula()
                            }
                        }) {
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
