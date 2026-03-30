import SwiftUI

struct FormulaListView: View {
    @State private var selectedCategory: CFOPStage = .cross
    @State private var showPractice = false

    private let formulas: [Formula] = CompleteFormulaData.shared.getAllFormulas()

    private var counts: [CFOPStage: Int] {
        CompleteFormulaData.shared.getCountByCategory()
    }

    private var filteredFormulas: [Formula] {
        formulas.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 顶部：练习按钮
            HStack {
                Text("CFOP公式")
                    .font(.title2)
                    .bold()

                Spacer()

                Button(action: {
                    showPractice = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "brain.head.profile")
                        Text("练习模式")
                    }
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            // 分类选择
            Picker("分类", selection: $selectedCategory) {
                ForEach(CFOPStage.allCases, id: \.self) { stage in
                    Text("\(stage.rawValue) (\(counts[stage] ?? 0))").tag(stage)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.bottom)

            // 公式列表
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredFormulas) { formula in
                        FormulaCard(formula: formula)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showPractice) {
            NavigationView {
                FormulaPracticeView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("完成") {
                                showPractice = false
                            }
                        }
                    }
            }
        }
    }
}

// 公式卡片组件 - 左边图片，右边公式
struct FormulaCard: View {
    let formula: Formula

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 左边：图片（135x135）
            if let imageName = formula.imageName {
                AsyncImage(imageName: imageName) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 135, height: 135)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 135, height: 135)
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

            // 右边：公式内容
            VStack(alignment: .leading, spacing: 8) {
                // 公式名称和分类标签
                HStack {
                    Text(formula.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Text(formula.category.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor(formula.category))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }

                // 公式算法
                Text(formula.algorithm)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)

                // 公式描述
                Text(formula.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
        )
    }

    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 135, height: 135)
            .overlay(
                VStack {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("暂无图片")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            )
    }

    private func categoryColor(_ category: CFOPStage) -> Color {
        switch category {
        case .cross: return .green
        case .f2l: return .blue
        case .oll: return .orange
        case .pll: return .purple
        }
    }
}

// 异步加载本地图片
struct AsyncImage: View {
    let imageName: String
    let content: (AsyncImagePhase) -> AnyView

    init<Content>(imageName: String, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) where Content: View {
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

    enum AsyncImagePhase {
        case empty
        case success(Image)
        case failure(Error)
    }
}

#Preview {
    FormulaListView()
}
