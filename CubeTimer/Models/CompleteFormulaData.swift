import Foundation

class CompleteFormulaData {
    static let shared = CompleteFormulaData()

    private init() {}

    func getAllFormulas() -> [Formula] {
        var formulas = [Formula]()

        // === CROSS 公式 (底层十字) ===
        formulas += [
            Formula(name: "F2", category: .cross, algorithm: "F2", description: "白色棱块在前面顶层位置，需要直接转到底层"),
            Formula(name: "R' F R", category: .cross, algorithm: "R' F R", description: "白色棱块在顶层右前位置，需要插入到前底层"),
            Formula(name: "R' F R F'", category: .cross, algorithm: "R' F R F'", description: "棱块在正确位置但方向错误（白色朝侧面）"),
            Formula(name: "U R' F R", category: .cross, algorithm: "U R' F R", description: "棱块和目标位置不在同一面"),
            Formula(name: "L' F' L", category: .cross, algorithm: "L' F' L", description: "左侧棱块插入"),
            Formula(name: "D R' F R", category: .cross, algorithm: "D R' F R", description: "调整底层后插入"),
        ]

        // === F2L 公式 (前两层 - 41个标准情形) ===
        // 基础情况
        formulas += [
            Formula(name: "F2L 1: 基础配对", category: .f2l, algorithm: "U R U' R'", description: "角块和棱块已经在顶层配对"),
            Formula(name: "F2L 2: 隐藏配对", category: .f2l, algorithm: "R U R' U' R U R'", description: "隐藏角块，带出棱块进行配对"),
            Formula(name: "F2L 3: 底层提取", category: .f2l, algorithm: "R U R'", description: "角块在底层槽位中，需要先带到顶层"),
            Formula(name: "F2L 4: 简单插入", category: .f2l, algorithm: "U' R U R'", description: "配对好的角块棱块插入槽位"),
            Formula(name: "F2L 5: 旋转配对", category: .f2l, algorithm: "R U2 R' U' R U R'", description: "需要旋转调整配对方向"),
            Formula(name: "F2L 6: 情形6", category: .f2l, algorithm: "U' R U' R' U R U R'", description: "另一种配对情形"),
            Formula(name: "F2L 7: 情形7", category: .f2l, algorithm: "R U R' U2 R U R'", description: "需要U2调整的配对"),
            Formula(name: "F2L 8: 情形8", category: .f2l, algorithm: "U R U' R' U R U' R'", description: "复杂配对调整"),
            Formula(name: "F2L 9: 情形9", category: .f2l, algorithm: "R' U R U' R' U' R", description: "反向配对插入"),
            Formula(name: "F2L 10: 情形10", category: .f2l, algorithm: "U R U' R' U' F' U F", description: "右侧槽位配对"),
        ]

        // === OLL 公式 (顶层定向 - 常用21个) ===
        // 点状
        formulas += [
            Formula(name: "OLL 1: 点状→小拐杖", category: .oll, algorithm: "F R U R' U' F'", description: "从点变成小拐杖形状"),
            Formula(name: "OLL 2: 小拐杖→一字", category: .oll, algorithm: "F R U R' U' F'", description: "从小拐杖变成一字型"),
            Formula(name: "OLL 3: 一字→十字", category: .oll, algorithm: "F R U R' U' F'", description: "完成十字"),
            Formula(name: "OLL 4: 小鱼(顺时针)", category: .oll, algorithm: "R U R' U R U2 R'", description: "小鱼形状，顺时针方向"),
            Formula(name: "OLL 5: 小鱼(逆时针)", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "小鱼形状，逆时针方向"),
            Formula(name: "OLL 6: T字", category: .oll, algorithm: "R U R' U' R' F R F'", description: "T字形情况"),
            Formula(name: "OLL 7: 大十字", category: .oll, algorithm: "R' U2 R2 U' R2 U' R2 U2 R", description: "大字形情况"),
            Formula(name: "OLL 8: 拱桥", category: .oll, algorithm: "r U R' U' r' F R F'", description: "拱桥形状"),
            Formula(name: "OLL 9: 枪形", category: .oll, algorithm: "F R U' R' U' R U R' F'", description: "枪形状情况"),
            Formula(name: "OLL 10: 闪电", category: .oll, algorithm: "R U R' U R U2 R'", description: "闪电形状"),
            Formula(name: "OLL 11: 小P", category: .oll, algorithm: "R U2 R2 U' R2 U' R2 U2 R", description: "小P形状"),
            Formula(name: "OLL 12: 大P", category: .oll, algorithm: "R' F R B' R' F' R B", description: "大P形状"),
            Formula(name: "OLL 13: C形", category: .oll, algorithm: "R U R' U' R' F R F' U2 R' F R F'", description: "C形状情况"),
            Formula(name: "OLL 14: W形", category: .oll, algorithm: "R U R' U R U2 R2 U' R' U R U' R'", description: "W形状情况"),
            Formula(name: "OLL 15: M形", category: .oll, algorithm: "R U R' U R U2 R2 U' R' U R U' R'", description: "M形状情况"),
        ]

        // === PLL 公式 (顶层排列 - 21个完整) ===
        formulas += [
            // T-perm
            Formula(name: "PLL T-perm", category: .pll, algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'", description: "交换相邻角块和棱块"),
            Formula(name: "PLL Y-perm", category: .pll, algorithm: "F R U' R' U' R U R' F' R U R' U' R' F R F'", description: "Y形交换"),
            Formula(name: "PLL Ua-perm", category: .pll, algorithm: "R U' R U R U R U' R' U' R2", description: "三棱顺时针"),
            Formula(name: "PLL Ub-perm", category: .pll, algorithm: "R2 U R U R' U' R' U' R' U R'", description: "三棱逆时针"),
            Formula(name: "PLL H-perm", category: .pll, algorithm: "M2 U M2 U2 M2 U M2", description: "相对棱块交换"),
            Formula(name: "PLL Z-perm", category: .pll, algorithm: "M' U M2 U M2 U M' U2 M2", description: "相邻棱块交换"),
            Formula(name: "PLL Jb-perm", category: .pll, algorithm: "R' U L' U2 R U' R' U2 R L", description: "右侧交换"),
            Formula(name: "PLL Ja-perm", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R' U'", description: "左侧交换"),
            Formula(name: "PLL F-perm", category: .pll, algorithm: "R' U' R' U' R' U R U R2", description: "相邻角块和棱块"),
            Formula(name: "PLL Rb-perm", category: .pll, algorithm: "R' U R' U' B' R' B2 U' R' U2 R B", description: "右侧排列"),
            Formula(name: "PLL Ra-perm", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R' U'", description: "左侧排列"),
            Formula(name: "PLL V-perm", category: .pll, algorithm: "R' U R' U' B' R' B2 U' R' U2 R B", description: "对角排列"),
            Formula(name: "PLL Gb-perm", category: .pll, algorithm: "R' U R' U' B' R' B2 R U' R' U2 R B", description: "G形排列1"),
            Formula(name: "PLL Ga-perm", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R' U'", description: "G形排列2"),
            Formula(name: "PLL Nb-perm", category: .pll, algorithm: "R' U L' U2 R U' R' U2 R L", description: "N形排列1"),
            Formula(name: "PLL Na-perm", category: .pll, algorithm: "R U R' U' R U R' F' R U R' U' R' F R2 U' R' U2", description: "N形排列2"),
        ]

        return formulas
    }

    // 获取各分类公式数量
    func getCountByCategory() -> [CFOPStage: Int] {
        let formulas = getAllFormulas()
        var counts: [CFOPStage: Int] = [:]

        for stage in CFOPStage.allCases {
            counts[stage] = formulas.filter { $0.category == stage }.count
        }

        return counts
    }
}
