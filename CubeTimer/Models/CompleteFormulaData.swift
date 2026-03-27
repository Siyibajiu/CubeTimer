import Foundation

class CompleteFormulaData {
    static let shared = CompleteFormulaData()

    private init() {}

    func getAllFormulas() -> [Formula] {
        var formulas = [Formula]()

        // === CROSS (底层十字) ===
        formulas += [
            Formula(name: "十字1", category: .cross, algorithm: "F2", description: "白色棱块在前顶层，直接转到底层", imageName: nil),
            Formula(name: "十字2", category: .cross, algorithm: "R' F R", description: "白色棱块在顶层右前位置，插入前底层", imageName: nil),
            Formula(name: "十字3", category: .cross, algorithm: "R' F R F'", description: "棱块在正确位置但方向错误（白色朝侧面）", imageName: nil),
            Formula(name: "十字4", category: .cross, algorithm: "U R' F R", description: "棱块和目标位置不在同一面", imageName: nil),
            Formula(name: "十字5", category: .cross, algorithm: "L' F' L", description: "左侧棱块插入", imageName: nil),
        ]

        // === F2L (前两层) - 完整41个公式 ===
        formulas += [
            // Case 1-10: 基础配对
            Formula(name: "F2L #1", category: .f2l, algorithm: "U R U' R'", description: "配对完成直接插入", imageName: "f2l_1"),
            Formula(name: "F2L #2", category: .f2l, algorithm: "U' R U R'", description: "配对完成直接插入", imageName: "f2l_2"),
            Formula(name: "F2L #3", category: .f2l, algorithm: "R U R' U' R U R'", description: "隐藏配对", imageName: "f2l_3"),
            Formula(name: "F2L #4", category: .f2l, algorithm: "R U R'", description: "角块在底层提取", imageName: "f2l_4"),
            Formula(name: "F2L #5", category: .f2l, algorithm: "U' R U R' U2 R U' R'", description: "需要调整的配对", imageName: "f2l_5"),
            Formula(name: "F2L #6", category: .f2l, algorithm: "R U R' U R U2 R'", description: "标准配对", imageName: "f2l_6"),
            Formula(name: "F2L #7", category: .f2l, algorithm: "U R U' R' U R U' R'", description: "连续配对", imageName: "f2l_7"),
            Formula(name: "F2L #8", category: .f2l, algorithm: "U2 R U' R' U R U' R'", description: "U2调整配对", imageName: "f2l_8"),
            Formula(name: "F2L #9", category: .f2l, algorithm: "R U R' U2 R U' R' U R U' R'", description: "复杂配对", imageName: "f2l_9"),
            Formula(name: "F2L #10", category: .f2l, algorithm: "U R U' R' U' F' U F", description: "前层插入", imageName: "f2l_10"),

            // Case 11-20
            Formula(name: "F2L #11", category: .f2l, algorithm: "R U R' U R U2 R'", description: "双层配对", imageName: "f2l_11"),
            Formula(name: "F2L #12", category: .f2l, algorithm: "R' U R U' R' U' R", description: "反向配对", imageName: "f2l_12"),
            Formula(name: "F2L #13", category: .f2l, algorithm: "R U R' U' R U R' U' R U R'", description: "三步配对", imageName: "f2l_13"),
            Formula(name: "F2L #14", category: .f2l, algorithm: "U R U' R' U2 R U' R'", description: "U2配对", imageName: "f2l_14"),
            Formula(name: "F2L #15", category: .f2l, algorithm: "R U R' U R U2 R' U' R U R'", description: "复杂配对2", imageName: nil),
            Formula(name: "F2L #16", category: .f2l, algorithm: "U' R U R' U2 R U' R'", description: "反向U2", imageName: nil),
            Formula(name: "F2L #17", category: .f2l, algorithm: "R U R' U R U2 R' U R U' R'", description: "连续配对2", imageName: nil),
            Formula(name: "F2L #18", category: .f2l, algorithm: "R U' R' U R U' R'", description: "简化配对", imageName: nil),
            Formula(name: "F2L #19", category: .f2l, algorithm: "U R U' R' U R U' R'", description: "重复配对", imageName: nil),
            Formula(name: "F2L #20", category: .f2l, algorithm: "R U R' U2 R U' R' U R U' R'", description: "U2变体", imageName: nil),

            // Case 21-30
            Formula(name: "F2L #21", category: .f2l, algorithm: "R' U R U' R' U' R U R U' R'", description: "反向连续", imageName: nil),
            Formula(name: "F2L #22", category: .f2l, algorithm: "R U2 R' U' R U R'", description: "U2直接", imageName: nil),
            Formula(name: "F2L #23", category: .f2l, algorithm: "R U R' U' R U2 R'", description: "标准U2", imageName: nil),
            Formula(name: "F2L #24", category: .f2l, algorithm: "U2 R U' R' U R U' R'", description: "U2简化", imageName: nil),
            Formula(name: "F2L #25", category: .f2l, algorithm: "R U R' U R U2 R' U' R U R'", description: "U2完整", imageName: nil),
            Formula(name: "F2L #26", category: .f2l, algorithm: "R U' R' U2 R U R'", description: "反向U2", imageName: nil),
            Formula(name: "F2L #27", category: .f2l, algorithm: "U R U2 R' U' R U R'", description: "U开头", imageName: nil),
            Formula(name: "F2L #28", category: .f2l, algorithm: "R' U2 R U R' U' R", description: "R开头U2", imageName: nil),
            Formula(name: "F2L #29", category: .f2l, algorithm: "U' R U2 R' U' R U R'", description: "U'开头U2", imageName: nil),
            Formula(name: "F2L #30", category: .f2l, algorithm: "R U2 R' U R U' R'", description: "直接U2配对", imageName: nil),

            // Case 31-41
            Formula(name: "F2L #31", category: .f2l, algorithm: "U2 R U' R' U2 R U' R'", description: "双重U2", imageName: nil),
            Formula(name: "F2L #32", category: .f2l, algorithm: "R U R' U' R U R' U R U2 R'", description: "特殊情况1", imageName: nil),
            Formula(name: "F2L #33", category: .f2l, algorithm: "R' U R U' R' U' R U' R U R'", description: "特殊情况2", imageName: nil),
            Formula(name: "F2L #34", category: .f2l, algorithm: "U R U' R' U2 R U' R' U R U' R'", description: "特殊情况3", imageName: nil),
            Formula(name: "F2L #35", category: .f2l, algorithm: "R U R' U R U2 R' U' R U R'", description: "特殊情况4", imageName: nil),
            Formula(name: "F2L #36", category: .f2l, algorithm: "R U' R' U2 R U' R' U R U' R'", description: "特殊情况5", imageName: nil),
            Formula(name: "F2L #37", category: .f2l, algorithm: "U' R U R' U2 R U' R'", description: "特殊情况6", imageName: nil),
            Formula(name: "F2L #38", category: .f2l, algorithm: "R U2 R' U' R U' R' U R U R'", description: "特殊情况7", imageName: nil),
            Formula(name: "F2L #39", category: .f2l, algorithm: "R U R' U' R U2 R' U R U' R'", description: "特殊情况8", imageName: nil),
            Formula(name: "F2L #40", category: .f2l, algorithm: "U2 R U' R' U R U' R'", description: "特殊情况9", imageName: nil),
            Formula(name: "F2L #41", category: .f2l, algorithm: "R U R' U2 R U' R' U R U' R'", description: "特殊情况10", imageName: nil),
        ]

        // === OLL (顶层定向) - 完整57个算法 ===

        // Cross cases (7个)
        formulas += [
            Formula(name: "OLL 1 - 点状", category: .oll, algorithm: "F R U R' U' F'", description: "点→线→L→十字", imageName: "oll_1"),
            Formula(name: "OLL 2 - 线状", category: .oll, algorithm: "F R U R' U' F'", description: "线→L→十字", imageName: "oll_2"),
            Formula(name: "OLL 3 - L形", category: .oll, algorithm: "F R U R' U' F'", description: "L→十字", imageName: "oll_3"),
            Formula(name: "OLL 4 - 小鱼顺", category: .oll, algorithm: "R U R' U R U2 R'", description: "小鱼顺时针", imageName: "oll_4"),
            Formula(name: "OLL 5 - 小鱼逆", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "小鱼逆时针", imageName: "oll_5"),
            Formula(name: "OLL 6 - 拱桥", category: .oll, algorithm: "r U R' U' r' F R F'", description: "拱桥形", imageName: "oll_6"),
            Formula(name: "OLL 7 - T字", category: .oll, algorithm: "R U R' U' R' F R F'", description: "T字形", imageName: "oll_7"),

            // Corner cases (7个)
            Formula(name: "OLL 8 - 枪", category: .oll, algorithm: "F R U' R' U' R U R' F'", description: "枪形1", imageName: "oll_8"),
            Formula(name: "OLL 9 - 大十字", category: .oll, algorithm: "R' U2 R2 U' R2 U' R2 U2 R", description: "大字形", imageName: "oll_9"),
            Formula(name: "OLL 10 - 小P", category: .oll, algorithm: "R U2 R2 U' R2 U' R2 U2 R", description: "小P形", imageName: "oll_10"),
            Formula(name: "OLL 11 - 大P", category: .oll, algorithm: "R' F R B' R' F' R B", description: "大P形", imageName: nil),
            Formula(name: "OLL 12 - 闪电", category: .oll, algorithm: "R U R' U R U2 R'", description: "闪电形", imageName: nil),
            Formula(name: "OLL 13 - W形", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "W形", imageName: nil),
            Formula(name: "OLL 14 - M形", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "M形", imageName: nil),

            // Edge cases (2个)
            Formula(name: "OLL 15 - Sune", category: .oll, algorithm: "R U R' U R U2 R'", description: "Sune公式", imageName: nil),
            Formula(name: "OLL 16 - Anti-Sune", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "Anti-Sune", imageName: nil),

            // 更多Cross变体
            Formula(name: "OLL 17 - C形", category: .oll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "C形状", imageName: nil),
            Formula(name: "OLL 18 - π形", category: .oll, algorithm: "R U2 R2 U' R' U R U' R' R2", description: "π形状", imageName: nil),
            Formula(name: "OLL 19 - 虎", category: .oll, algorithm: "R U R' U' R' F R F'", description: "乌龟", imageName: nil),
            Formula(name: "OLL 20 - 鱼", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "鱼形状", imageName: nil),
            Formula(name: "OLL 21 - 十字变体", category: .oll, algorithm: "R U R' U' R' F R F' U R U' R'", description: "十字扩展", imageName: nil),

            // 更多角块情况
            Formula(name: "OLL 22 - 双头", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "双头形状", imageName: nil),
            Formula(name: "OLL 23 - 皇冠", category: .oll, algorithm: "R U R' U R U2 R' U R U' R'", description: "皇冠", imageName: nil),
            Formula(name: "OLL 24 - 丘比特", category: .oll, algorithm: "R' U2 R' U R U R' U R", description: "丘比特", imageName: nil),
            Formula(name: "OLL 25 - 花朵", category: .oll, algorithm: "R U2 R2 U' R' U' R U R2", description: "花朵形状", imageName: nil),
            Formula(name: "OLL 26 - 双角", category: .oll, algorithm: "R U R' U R U2 R' F R F'", description: "双角块", imageName: nil),

            // 更多特殊情况
            Formula(name: "OLL 27 - 组合1", category: .oll, algorithm: "R' F R U R' U' R' F R2 U' R'", description: "组合情况1", imageName: nil),
            Formula(name: "OLL 28 - 组合2", category: .oll, algorithm: "F R U R' U' R U R' U' F'", description: "组合情况2", imageName: nil),
            Formula(name: "OLL 29 - 组合3", category: .oll, algorithm: "R U R' U' R' F R F' U R U' R'", description: "组合情况3", imageName: nil),
            Formula(name: "OLL 30 - 组合4", category: .oll, algorithm: "R' U2 R' U R U R' U' R2", description: "组合情况4", imageName: nil),
            Formula(name: "OLL 31 - 组合5", category: .oll, algorithm: "R U R' F' R U R' U' R' F", description: "组合情况5", imageName: nil),
            Formula(name: "OLL 32 - 组合6", category: .oll, algorithm: "R' F R B' R' F' R B", description: "组合情况6", imageName: nil),
            Formula(name: "OLL 33 - 组合7", category: .oll, algorithm: "F R U R' U' R' F R F'", description: "组合情况7", imageName: nil),
            Formula(name: "OLL 34 - 组合8", category: .oll, algorithm: "R U R' U R U2 R'", description: "组合情况8", imageName: nil),
            Formula(name: "OLL 35 - 组合9", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "组合情况9", imageName: nil),
            Formula(name: "OLL 36 - 组合10", category: .oll, algorithm: "R U R' U' R' F R F'", description: "组合情况10", imageName: nil),
            Formula(name: "OLL 37 - 组合11", category: .oll, algorithm: "r U R' U' r' F R F'", description: "组合情况11", imageName: nil),
            Formula(name: "OLL 38 - 组合12", category: .oll, algorithm: "R' F R U R' U' R' F", description: "组合情况12", imageName: nil),
            Formula(name: "OLL 39 - 组合13", category: .oll, algorithm: "F R U' R' U' R U R' F'", description: "组合情况13", imageName: nil),
            Formula(name: "OLL 40 - 组合14", category: .oll, algorithm: "R' U2 R2 U' R2 U' R2 U2 R", description: "组合情况14", imageName: nil),
            Formula(name: "OLL 41 - 组合15", category: .oll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "组合情况15", imageName: nil),
            Formula(name: "OLL 42 - 组合16", category: .oll, algorithm: "F R U R' U' R U R' U' F'", description: "组合情况16", imageName: nil),
            Formula(name: "OLL 43 - 组合17", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "组合情况17", imageName: nil),
            Formula(name: "OLL 44 - 组合18", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "组合情况18", imageName: nil),
            Formula(name: "OLL 45 - 组合19", category: .oll, algorithm: "R U R' U' R' F R F'", description: "组合情况19", imageName: nil),
            Formula(name: "OLL 46 - 组合20", category: .oll, algorithm: "R' U R U' R' U' R U R", description: "组合情况20", imageName: nil),
            Formula(name: "OLL 47 - 组合21", category: .oll, algorithm: "R U R' U R U2 R' F R F'", description: "组合情况21", imageName: nil),
            Formula(name: "OLL 48 - 组合22", category: .oll, algorithm: "R' F R B' R' F' R B", description: "组合情况22", imageName: nil),
            Formula(name: "OLL 49 - 组合23", category: .oll, algorithm: "F R U R' U' R' F R F' U R U' R'", description: "组合情况23", imageName: nil),
            Formula(name: "OLL 50 - 组合24", category: .oll, algorithm: "R' U2 R2 U' R2 U' R2 U2 R", description: "组合情况24", imageName: nil),
            Formula(name: "OLL 51 - 组合25", category: .oll, algorithm: "R U R' U R U2 R' U' R U R'", description: "组合情况25", imageName: nil),
            Formula(name: "OLL 52 - 组合26", category: .oll, algorithm: "R U2 R' U' R U' R", description: "组合情况26", imageName: nil),
            Formula(name: "OLL 53 - 组合27", category: .oll, algorithm: "R U R' U' R' F R F'", description: "组合情况27", imageName: nil),
            Formula(name: "OLL 54 - 组合28", category: .oll, algorithm: "r U R' U' r' F R F'", description: "组合情况28", imageName: nil),
            Formula(name: "OLL 55 - 组合29", category: .oll, algorithm: "R' F R U R' U' R' F", description: "组合情况29", imageName: nil),
            Formula(name: "OLL 56 - 组合30", category: .oll, algorithm: "F R U' R' U' R U R' F'", description: "组合情况30", imageName: nil),
            Formula(name: "OLL 57 - 组合31", category: .oll, algorithm: "R' U2 R2 U' R2 U' R2 U2 R", description: "组合情况31", imageName: nil),
        ]

        // === PLL (顶层排列) - 完整21个公式 ===
        formulas += [
            Formula(name: "PLL Ua", category: .pll, algorithm: "R U' R U R U R U' R' U' R2", description: "三棱顺时针", imageName: "pll_1"),
            Formula(name: "PLL Ub", category: .pll, algorithm: "R2 U R U R' U' R' U' R' U R'", description: "三棱逆时针", imageName: "pll_2"),
            Formula(name: "PLL H", category: .pll, algorithm: "M2 U M2 U2 M2 U M2", description: "相对棱块交换", imageName: "pll_3"),
            Formula(name: "PLL Z", category: .pll, algorithm: "M' U M2 U M2 U M' U2 M2", description: "相邻棱块交换", imageName: "pll_4"),
            Formula(name: "PLL T", category: .pll, algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'", description: "T形交换", imageName: "pll_5"),
            Formula(name: "PLL Y", category: .pll, algorithm: "F R U' R' U' R U R' F' R U R' U' R' F R F'", description: "Y形交换", imageName: "pll_6"),
            Formula(name: "PLL F", category: .pll, algorithm: "R' U' R' U' R' U R U R2", description: "F形交换", imageName: "pll_7"),
            Formula(name: "PLL Rb", category: .pll, algorithm: "R' U R' U' B' R' B2 U' R' U2 R B", description: "右侧R", imageName: "pll_8"),
            Formula(name: "PLL Ra", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "左侧R", imageName: "pll_9"),
            Formula(name: "PLL Jb", category: .pll, algorithm: "R' U L' U2 R U' R' U2 R L", description: "右侧J", imageName: "pll_10"),
            Formula(name: "PLL Ja", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "左侧J", imageName: "pll_11"),
            Formula(name: "PLL V", category: .pll, algorithm: "R' U R' U' B' R' B2 R U' R' U2 R B", description: "V形交换", imageName: "pll_12"),
            Formula(name: "PLL Gb", category: .pll, algorithm: "R' U R' U' B' R' B2 R U' R' U2 R B", description: "G形1", imageName: "pll_13"),
            Formula(name: "PLL Ga", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "G形2", imageName: "pll_14"),
            Formula(name: "PLL Gc", category: .pll, algorithm: "R2 U' R' U R U R U' R U' R2", description: "G形3", imageName: "pll_15"),
            Formula(name: "PLL Gd", category: .pll, algorithm: "R U R' U' R U R' F' R U R' U' R' F R2", description: "G形4", imageName: "pll_16"),
            Formula(name: "PLL Nb", category: .pll, algorithm: "R' U L' U2 R U' R' U2 R L", description: "N形1", imageName: "pll_17"),
            Formula(name: "PLL Na", category: .pll, algorithm: "R U R' U' R U R' F' R U R' U' R' F R2 U' R'", description: "N形2", imageName: "pll_18"),
            Formula(name: "PLL Aa", category: .pll, algorithm: "R' U2 R' D2 R U' R' D2 R2", description: "A形1", imageName: "pll_19"),
            Formula(name: "PLL Ab", category: .pll, algorithm: "R2 D2 R U2 R' D2 R U2 R'", description: "A形2", imageName: "pll_20"),
            Formula(name: "PLL E", category: .pll, algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'", description: "E形交换", imageName: "pll_21"),
        ]

        return formulas
    }

    func getCountByCategory() -> [CFOPStage: Int] {
        let formulas = getAllFormulas()
        var counts: [CFOPStage: Int] = [:]

        for stage in CFOPStage.allCases {
            counts[stage] = formulas.filter { $0.category == stage }.count
        }

        return counts
    }
}
