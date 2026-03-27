import SwiftUI

struct FormulaListView: View {
    @State private var selectedCategory: CFOPStage = .cross

    private let formulas: [Formula] = FormulaData.shared.getAllFormulas()

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

            // 公式数量
            Text("共 \(filteredFormulas.count) 个公式")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)

            // 公式列表
            List(filteredFormulas) { formula in
                VStack(alignment: .leading, spacing: 12) {
                    // 公式名称
                    Text(formula.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    // 公式算法
                    Text(formula.algorithm)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                    // 公式描述
                    Text(formula.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
        .navigationTitle("CFOP公式")
    }
}

#Preview {
    FormulaListView()
}
