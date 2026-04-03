import Foundation

/// CFOP 完整公式数据聚合器
/// 从 F2L、OLL、PLL 三个模块化数据源获取所有公式
class CompleteFormulaData {
    static let shared = CompleteFormulaData()

    // 静态常量，只创建一次
    private static let allFormulas: [Formula] = {
        var formulas = [Formula]()

        // 从三个模块化数据源聚合
        formulas += F2LData.shared.getAllFormulas()
        formulas += OLLData.shared.getAllFormulas()
        formulas += PLLData.shared.getAllFormulas()

        return formulas
    }()

    private init() {}

    func getAllFormulas() -> [Formula] {
        return Self.allFormulas
    }

    private static var cachedCounts: [CFOPStage: Int]?

    func getCountByCategory() -> [CFOPStage: Int] {
        if let cached = Self.cachedCounts {
            return cached
        }

        var counts: [CFOPStage: Int] = [:]
        for stage in CFOPStage.allCases {
            counts[stage] = Self.allFormulas.filter { $0.category == stage }.count
        }

        Self.cachedCounts = counts
        return counts
    }
}
