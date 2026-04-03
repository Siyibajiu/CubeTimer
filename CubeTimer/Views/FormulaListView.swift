import SwiftUI

struct FormulaListView: View {
    @State private var selectedCategory: CFOPStage = .f2l
    @State private var selectedOLLShape: String? = nil  // OLL形状分类
    @State private var showPractice = false
    @State private var showErrorsOnly = false
    @StateObject private var viewModel = PracticeViewModel()

    // 性能优化：缓存计算结果
    @State private var cachedFormulas: [Formula] = []
    @State private var cachedOLLCategories: [(key: String, count: Int)] = []
    @State private var cachedOLLFormulasByShape: [String: [Formula]] = [:]

    // 数据源已内部缓存，直接调用即可
    private var formulas: [Formula] { cachedFormulas }
    private var counts: [CFOPStage: Int] { CompleteFormulaData.shared.getCountByCategory() }

    private var filteredFormulas: [Formula] {
        var result = formulas.filter { formula in
            formula.category == selectedCategory &&
            (showErrorsOnly ? viewModel.hasError(formula) : true)
        }

        // 如果是OLL且有选择的形状，使用缓存的分类数据（比字符串搜索快）
        if selectedCategory == .oll, let selectedShape = selectedOLLShape {
            result = cachedOLLFormulasByShape[selectedShape] ?? []
        }

        return result
    }

    // 获取当前OLL分类列表（从缓存中获取）
    private var currentOLLCategories: [(key: String, count: Int)] {
        selectedCategory == .oll ? cachedOLLCategories : []
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
            .padding(.bottom, 8)
            .onChange(of: selectedCategory) { _ in
                // 切换分类时重置OLL形状选择
                selectedOLLShape = nil
            }

            // OLL形状分类选择（仅在选择OLL时显示）
            if selectedCategory == .oll {
                VStack(alignment: .leading, spacing: 4) {
                    Text("按形状筛选")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    Picker("OLL形状", selection: $selectedOLLShape) {
                        Text("全部 OLL").tag(nil as String?)
                        ForEach(currentOLLCategories, id: \.key) { category in
                            Text("\(category.key) (\(category.count))").tag(category.key as String?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            // 筛选开关
            HStack {
                Toggle("仅显示有错误的公式", isOn: $showErrorsOnly)
                    .font(.subheadline)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.bottom, 8)

            // 公式列表
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredFormulas) { formula in
                        FormulaCard(formula: formula, viewModel: viewModel)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showPractice) {
            FormulaPracticeView()
        }
        .onAppear {
            // 初始化缓存
            initializeCaches()
            viewModel.loadFormulas(category: nil)
        }
    }

    // 初始化缓存数据（性能优化）
    private func initializeCaches() {
        // 缓存所有公式
        cachedFormulas = CompleteFormulaData.shared.getAllFormulas()

        // 预先计算并缓存OLL分类数据
        let ollCategoriesData = OLLData.shared.getFormulasByCategory()

        // 定义中文分类名到英文分类名的映射
        let categoryMapping: [String: String] = [
            "OCLL (棱块已定向)": "OCLL",
            "Dot (无棱块定向)": "Dot",
            "S 形状": "S",
            "大闪电形状": "Big Bolt",
            "小闪电形状": "Small Bolt",
            "鱼形": "Fish",
            "马步形": "Knight",
            "Awkward 形状": "Awkward",
            "P 形状": "P",
            "W 形状": "W",
            "L 形状": "L",
            "C 形状": "C",
            "T 形状": "T",
            "I 形状": "I",
            "E 形状 (角块已定向)": "E"
        ]

        // 缓存OLL分类列表
        cachedOLLCategories = ollCategoriesData.map { (key, value) in
            let shortName = categoryMapping[key] ?? key
            return (key: shortName, count: value.count)
        }
        .sorted { $0.key < $1.key }

        // 缓存每个分类的公式列表（避免重复过滤）
        for (shortName, _) in cachedOLLCategories {
            // 找到对应英文简称的中文分类名
            if let chineseKey = categoryMapping.first(where: { $0.value == shortName })?.key {
                cachedOLLFormulasByShape[shortName] = ollCategoriesData[chineseKey] ?? []
            }
        }
    }
}

// 公式卡片组件 - 左边图片，右边公式
struct FormulaCard: View {
    let formula: Formula
    @ObservedObject var viewModel: PracticeViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 左边：图片（135x135）
            if let imageName = formula.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 135, height: 135)
                    .rotationEffect(.degrees(formula.rotation))
                    .clipped()
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

                    // 分类标签
                    Text(formula.category.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(categoryColor(formula.category))
                        .foregroundColor(.white)
                        .cornerRadius(6)

                    // 错误标记按钮
                    Button(action: {
                        viewModel.toggleError(formula)
                    }) {
                        Image(systemName: viewModel.hasError(formula) ? "xmark.circle.fill" : "xmark.circle")
                            .font(.title3)
                            .foregroundColor(viewModel.hasError(formula) ? .red : .gray)
                    }
                    .buttonStyle(.plain)
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
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.hasError(formula) ? Color.red.opacity(0.05) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(viewModel.hasError(formula) ? Color.red : Color.clear, lineWidth: 2)
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
        case .f2l: return .blue
        case .oll: return .orange
        case .pll: return .purple
        }
    }
}

#Preview {
    FormulaListView()
}
