import SwiftUI

struct FormulaListView: View {
    @State private var selectedCategory: CFOPStage = .cross

    private let formulas: [Formula] = CompleteFormulaData.shared.getAllFormulas()

    private var counts: [CFOPStage: Int] {
        CompleteFormulaData.shared.getCountByCategory()
    }

    private var filteredFormulas: [Formula] {
        formulas.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(spacing: 0) {
            // 分类选择
            Picker("分类", selection: $selectedCategory) {
                ForEach(CFOPStage.allCases, id: \.self) { stage in
                    Text("\(stage.rawValue) (\(counts[stage] ?? 0))").tag(stage)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // 公式列表
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredFormulas) { formula in
                        FormulaCard(formula: formula)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("CFOP公式")
    }
}

// 公式卡片组件
struct FormulaCard: View {
    let formula: Formula

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 公式图案
            CubePatternView(formulaName: formula.name, category: formula.category)

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
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)

            // 公式描述
            Text(formula.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private var gradientColor: Color {
        switch formula.category {
        case .cross: return .green
        case .f2l: return .blue
        case .oll: return .orange
        case .pll: return .purple
        }
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

#Preview {
    FormulaListView()
}
