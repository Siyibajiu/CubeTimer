import SwiftUI

struct FormulaListView: View {
    @State private var selectedCategory: CFOPStage = .cross

    // 示例数据
    private let formulas: [Formula] = [
        Formula(name: "底层十字基础", category: .cross, algorithm: "R U R' U'", description: "基础复原公式"),
        Formula(name: "F2L基础", category: .f2l, algorithm: "R U R'", description: "前两层复原"),
        Formula(name: "OLL公式1", category: .oll, algorithm: "R U R' U R U2 R'", description: "顶层定向"),
        Formula(name: "PLL公式1", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "顶层排列"),
    ]

    private var filteredFormulas: [Formula] {
        formulas.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack {
            // 分类选择
            Picker("分类", selection: $selectedCategory) {
                ForEach(CFOPStage.allCases, id: \.self) { stage in
                    Text(stage.rawValue).tag(stage)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // 公式列表
            List(filteredFormulas) { formula in
                VStack(alignment: .leading, spacing: 8) {
                    Text(formula.name)
                        .font(.headline)
                    Text(formula.algorithm)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                    Text(formula.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("CFOP公式")
    }
}

#Preview {
    FormulaListView()
}
