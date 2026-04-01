import Foundation

class CompleteFormulaData {
    static let shared = CompleteFormulaData()

    private init() {}

    func getAllFormulas() -> [Formula] {
        var formulas = [Formula]()

        // === F2L (前两层) - 从 CubeSkills PDF 提取的 41 个标准算法 ===
        formulas += [
            Formula(name: "F2L #1", category: .f2l, algorithm: "U (R U' R') ", description: "F2L标准算法", imageName: "f2l_2"),
            Formula(name: "F2L #2", category: .f2l, algorithm: "y' U' (R' U R)", description: "F2L标准算法", imageName: "f2l_3"),
            Formula(name: "F2L #3", category: .f2l, algorithm: "y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_4"),
            Formula(name: "F2L #4", category: .f2l, algorithm: "(R U R')", description: "F2L标准算法", imageName: "f2l_5"),
            Formula(name: "F2L #5", category: .f2l, algorithm: "U' (R U' R' U) y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_6"),
            Formula(name: "F2L #6", category: .f2l, algorithm: "U' (R U R' U) (R U R')", description: "F2L标准算法", imageName: "f2l_7"),
            Formula(name: "F2L #7", category: .f2l, algorithm: "U' (R U2' R' U) y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_8"),
            Formula(name: "F2L #8", category: .f2l, algorithm: "R' U2' R2 U R2' U R", description: "F2L标准算法", imageName: "f2l_9"),
            Formula(name: "F2L #9", category: .f2l, algorithm: "y' U (R' U R U') (R' U' R)", description: "F2L标准算法", imageName: "f2l_10"),
            Formula(name: "F2L #10", category: .f2l, algorithm: "U' (R U' R' U) (R U R')", description: "F2L标准算法", imageName: "f2l_11"),
            Formula(name: "F2L #11", category: .f2l, algorithm: "(U' R U R') U2 (R U' R')", description: "F2L标准算法", imageName: "f2l_12"),
            Formula(name: "F2L #12", category: .f2l, algorithm: "y' (U R' U' R) U2' (R' U R)", description: "F2L标准算法", imageName: "f2l_13"),
            Formula(name: "F2L #13", category: .f2l, algorithm: "U' (R U2' R') U2 (R U' R')", description: "F2L标准算法", imageName: "f2l_14"),
            Formula(name: "F2L #14", category: .f2l, algorithm: "y' U (R' U2 R) U2' (R' U R)", description: "F2L标准算法", imageName: "f2l_15"),
            Formula(name: "F2L #15", category: .f2l, algorithm: "U (R U2 R') U (R U' R')", description: "F2L标准算法", imageName: "f2l_16"),
            Formula(name: "F2L #16", category: .f2l, algorithm: "y' U' (R' U2 R) U' (R' U R)", description: "F2L标准算法", imageName: "f2l_17"),
            Formula(name: "F2L #17", category: .f2l, algorithm: "U2 (R U R' U) (R U' R')", description: "F2L标准算法", imageName: "f2l_18"),
            Formula(name: "F2L #18", category: .f2l, algorithm: "y' U2 (R' U' R) U' (R' U R)", description: "F2L标准算法", imageName: "f2l_19"),
            Formula(name: "F2L #19", category: .f2l, algorithm: "y' (R' U R) U2' y (R U R')", description: "F2L标准算法", imageName: "f2l_20"),
            Formula(name: "F2L #20", category: .f2l, algorithm: "(R U' R' U2) y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_21"),
            Formula(name: "F2L #21", category: .f2l, algorithm: "(R U2 R') U' (R U R') ", description: "F2L标准算法", imageName: "f2l_22"),
            Formula(name: "F2L #22", category: .f2l, algorithm: "y' (R' U2 R) U (R' U' R)", description: "F2L标准算法", imageName: "f2l_23"),
            Formula(name: "F2L #23", category: .f2l, algorithm: "U (R U' R' U') (R U' R' U) (R U' R')", description: "F2L标准算法", imageName: "f2l_24"),
            Formula(name: "F2L #24", category: .f2l, algorithm: "F (U R U' R') F' (R U' R')", description: "F2L标准算法", imageName: "f2l_25"),
            Formula(name: "F2L #25", category: .f2l, algorithm: "R' F' R U (R U' R') F", description: "F2L标准算法", imageName: "f2l_26"),
            Formula(name: "F2L #26", category: .f2l, algorithm: "U (R U' R') (F R' F' R)", description: "F2L标准算法", imageName: "f2l_27"),
            Formula(name: "F2L #27", category: .f2l, algorithm: "(R U' R' U) (R U' R') ", description: "F2L标准算法", imageName: "f2l_28"),
            Formula(name: "F2L #28", category: .f2l, algorithm: "y' (R' U R U') (R' U R)", description: "F2L标准算法", imageName: "f2l_29"),
            Formula(name: "F2L #29", category: .f2l, algorithm: "(R' F R F') U (R U' R')", description: "F2L标准算法", imageName: "f2l_30"),
            Formula(name: "F2L #30", category: .f2l, algorithm: "(R U R' U') (R U R')", description: "F2L标准算法", imageName: "f2l_31"),
            Formula(name: "F2L #31", category: .f2l, algorithm: "U' (R' F R F') (R U' R')", description: "F2L标准算法", imageName: "f2l_32"),
            Formula(name: "F2L #32", category: .f2l, algorithm: "(U R U' R') (U R U' R') (U R U' R')", description: "F2L标准算法", imageName: "f2l_33"),
            Formula(name: "F2L #33", category: .f2l, algorithm: "(U' R U' R') U2 (R U' R')", description: "F2L标准算法", imageName: "f2l_34"),
            Formula(name: "F2L #34", category: .f2l, algorithm: "U (R U R') U2 (R U R')", description: "F2L标准算法", imageName: "f2l_35"),
            Formula(name: "F2L #35", category: .f2l, algorithm: "(U' R U R') U y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_36"),
            Formula(name: "F2L #36", category: .f2l, algorithm: "U (F' U' F) U' (R U R')", description: "F2L标准算法", imageName: "f2l_37"),
            Formula(name: "F2L #37", category: .f2l, algorithm: "Solved Pair ", description: "F2L标准算法", imageName: "f2l_38"),
            Formula(name: "F2L #38", category: .f2l, algorithm: "(R U' R') d (R' U2 R) U2' (R' U R)", description: "F2L标准算法", imageName: "f2l_39"),
            Formula(name: "F2L #39", category: .f2l, algorithm: "(R U R' U') R U2 R' U' (R U R')", description: "F2L标准算法", imageName: "f2l_40"),
            Formula(name: "F2L #40", category: .f2l, algorithm: "(R U R') U2' (R U' R' U) (R U R')", description: "F2L标准算法", imageName: "f2l_41"),
            Formula(name: "F2L #41", category: .f2l, algorithm: "(F' U F) U2 (R U R' U) (R U' R')", description: "F2L标准算法", imageName: "f2l_42"),
            Formula(name: "F2L #42", category: .f2l, algorithm: "(R U R' U') (R U' R') U2 y' (R' U' R)", description: "F2L标准算法", imageName: "f2l_43"),
        ]

        // === OLL (顶层定向) - 从 CubeSkills PDF 提取的 48 个标准算法 ===

        formulas += [
            Formula(name: "OLL 2 - OCLL2", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "OLL标准算法 - 概率1/22", imageName: "oll_2"),
            Formula(name: "OLL 3 - OCLL3", category: .oll, algorithm: "R U R' U R U2' R'", description: "OLL标准算法 - 概率1/23", imageName: "oll_3"),
            Formula(name: "OLL 4 - OCLL4", category: .oll, algorithm: "(R U2 R') (U' R U R') (U' R U' R')", description: "OLL标准算法 - 概率1/24", imageName: "oll_4"),
            Formula(name: "OLL 5 - OCLL5", category: .oll, algorithm: "R U2' R2' U' R2 U' R2' U2' R", description: "OLL标准算法 - 概率1/25", imageName: "oll_5"),
            Formula(name: "OLL 6 - OCLL6", category: .oll, algorithm: "(r U R' U') (r' F R F')", description: "OLL标准算法 - 概率1/26", imageName: "oll_6"),
            Formula(name: "OLL 7 - OCLL7", category: .oll, algorithm: "y F' (r U R' U') r' F R", description: "OLL标准算法 - 概率1/27", imageName: "oll_7"),
            Formula(name: "OLL 8 - OCLL3 - 23", category: .oll, algorithm: "R2 D (R' U2 R) D' (R' U2 R')", description: "OLL标准算法 - 概率1/33", imageName: "oll_8"),
            Formula(name: "OLL 9 - T1", category: .oll, algorithm: "(R U R' U') (R' F R F')", description: "OLL标准算法 - 概率1/45", imageName: "oll_9"),
            Formula(name: "OLL 10 - T2", category: .oll, algorithm: "F (R U R' U') F'", description: "OLL标准算法 - 概率1/5", imageName: "oll_10"),
            Formula(name: "OLL 11 - S2", category: .oll, algorithm: "(R U R2' U') (R' F R U) R U' F'", description: "OLL标准算法 - 概率1/6", imageName: "oll_11"),
            Formula(name: "OLL 12 - C1", category: .oll, algorithm: "R' U' (R' F R F') U R", description: "OLL标准算法 - 概率1/34", imageName: "oll_12"),
            Formula(name: "OLL 13 - C2", category: .oll, algorithm: "(R' U' R U') (R' U R U) l U' R' U x", description: "OLL标准算法 - 概率1/46", imageName: "oll_13"),
            Formula(name: "OLL 14 - W1", category: .oll, algorithm: "(r U R' U') M (U R U' R')", description: "OLL标准算法 - 概率1/36", imageName: "oll_14"),
            Formula(name: "OLL 15 - W2", category: .oll, algorithm: "(R U R' U') M' (U R U' r')", description: "OLL标准算法 - 概率1/38", imageName: "oll_15"),
            Formula(name: "OLL 16 - E1", category: .oll, algorithm: "(R' U' F) (U R U' R') F' R", description: "OLL标准算法 - 概率1/28", imageName: "oll_16"),
            Formula(name: "OLL 17 - E2", category: .oll, algorithm: "R U B' (U' R' U) (R B R')", description: "OLL标准算法 - 概率1/57", imageName: "oll_17"),
            Formula(name: "OLL 18 - P1", category: .oll, algorithm: "f (R U R' U') (R U R' U') f'", description: "OLL标准算法 - 概率1/31", imageName: "oll_18"),
            Formula(name: "OLL 19 - P2", category: .oll, algorithm: "r' U' r (U' R' U R) (U' R' U R) r' U r", description: "OLL标准算法 - 概率1/32", imageName: "oll_19"),
            Formula(name: "OLL 20 - P3", category: .oll, algorithm: "(R U R' U R U') y (R U' R') F'", description: "OLL标准算法 - 概率1/43", imageName: "oll_20"),
            Formula(name: "OLL 21 - P4", category: .oll, algorithm: "y (R' F R U) (R U' R2' F') R2 U' R' (U R U R')", description: "OLL标准算法 - 概率1/44", imageName: "oll_21"),
            Formula(name: "OLL 22 - I1", category: .oll, algorithm: "(R' U' R) y r U' r' U r U r'", description: "OLL标准算法 - 概率1/51", imageName: "oll_22"),
            Formula(name: "OLL 23 - I2", category: .oll, algorithm: "(R U R') y (R' F R U') (R' F' R)", description: "OLL标准算法 - 概率1/52", imageName: "oll_23"),
            Formula(name: "OLL 24 - I3", category: .oll, algorithm: "F U R U' R2' F' R U (R U' R')", description: "OLL标准算法 - 概率1/55", imageName: "oll_24"),
            Formula(name: "OLL 25 - I4", category: .oll, algorithm: "(R' F R) (U R' F' R) (F U' F')", description: "OLL标准算法 - 概率1/56", imageName: "oll_25"),
            Formula(name: "OLL 26 - F1", category: .oll, algorithm: "(r U r') (R U R' U') (r U' r')", description: "OLL标准算法 - 概率1/9", imageName: "oll_26"),
            Formula(name: "OLL 27 - F2", category: .oll, algorithm: "(r' U' r) (R' U' R U) (r' U r)", description: "OLL标准算法 - 概率1/10", imageName: "oll_27"),
            Formula(name: "OLL 28 - F3", category: .oll, algorithm: "M U (R U R' U')(R' F R F') M'", description: "OLL标准算法 - 概率1/35", imageName: "oll_28"),
            Formula(name: "OLL 29 - F4", category: .oll, algorithm: "F (R U R' U') (R U R' U') F'", description: "OLL标准算法 - 概率1/37", imageName: "oll_29"),
            Formula(name: "OLL 30 - K1", category: .oll, algorithm: "F' (L' U' L U) (L' U' L U) F", description: "OLL标准算法 - 概率1/13", imageName: "oll_30"),
            Formula(name: "OLL 31 - K2", category: .oll, algorithm: "r U' r2' U r2 U r2' U' r", description: "OLL标准算法 - 概率1/14", imageName: "oll_31"),
            Formula(name: "OLL 32 - K3", category: .oll, algorithm: "(r' U' R U') (R' U R U') R' U2 r", description: "OLL标准算法 - 概率1/16", imageName: "oll_32"),
            Formula(name: "OLL 33 - K4", category: .oll, algorithm: "(r U R' U) (R U' R' U) R U2' r'", description: "OLL标准算法 - 概率1/15", imageName: "oll_33"),
            Formula(name: "OLL 34 - A1", category: .oll, algorithm: "(R' F) (R U R' U') F' U R", description: "OLL标准算法 - 概率1/29", imageName: "oll_34"),
            Formula(name: "OLL 35 - A2", category: .oll, algorithm: "M U (R U R' U')(R' F R F') M'", description: "OLL标准算法 - 概率1/30", imageName: "oll_35"),
            Formula(name: "OLL 36 - A3", category: .oll, algorithm: "(R U2') (R2' F R F') U2' (R' F R F')", description: "OLL标准算法 - 概率1/41", imageName: "oll_36"),
            Formula(name: "OLL 37 - A4", category: .oll, algorithm: "F (R U R' U') F' f (R U R' U') f'", description: "OLL标准算法 - 概率1/42", imageName: "oll_37"),
            Formula(name: "OLL 38 - L1", category: .oll, algorithm: "f (R U R' U') f' U' F (R U R' U') F'", description: "OLL标准算法 - 概率1/47", imageName: "oll_38"),
            Formula(name: "OLL 39 - L2", category: .oll, algorithm: "f (R U R' U') f' U F (R U R' U') F'", description: "OLL标准算法 - 概率1/48", imageName: "oll_39"),
            Formula(name: "OLL 40 - L3", category: .oll, algorithm: "(r U R' U R U2 r') (r' U' R U' R' U2 r)", description: "OLL标准算法 - 概率1/49", imageName: "oll_40"),
            Formula(name: "OLL 41 - L4", category: .oll, algorithm: "M U (R U R' U') M' (R' F R F')", description: "OLL标准算法 - 概率1/50", imageName: "oll_41"),
            Formula(name: "OLL 42 - L5", category: .oll, algorithm: "(R U R' U) (R' F R F') U2' (R' F R F')", description: "OLL标准算法 - 概率1/53", imageName: "oll_42"),
            Formula(name: "OLL 43 - L6", category: .oll, algorithm: "M U (R U R' U') M2' (U R U' r')", description: "OLL标准算法 - 概率1/54", imageName: "oll_43"),
        ]

        // === PLL (顶层排列) - 从 CubeSkills PDF 提取的 21 个标准算法 ===
        formulas += [
            Formula(name: "PLL Ub", category: .pll, algorithm: "R2 U (R U R' U') R' U' (R' U R')", description: "PLL标准算法 - 概率1/18", imageName: "pll_1"),
            Formula(name: "PLL Ua", category: .pll, algorithm: "(R U' R U) R U (R U' R' U') R2", description: "PLL标准算法 - 概率1/18", imageName: "pll_2"),
            Formula(name: "PLL Z", category: .pll, algorithm: "(M2' U M2' U) (M' U2) (M2' U2 M')", description: "PLL标准算法 - 概率1/36", imageName: "pll_3"),
            Formula(name: "PLL H", category: .pll, algorithm: "(M2' U M2') U2 (M2' U M2')", description: "PLL标准算法 - 概率1/72", imageName: "pll_4"),
            Formula(name: "PLL Aa", category: .pll, algorithm: "x (R' U R') D2 (R U' R') D2 R2 x'", description: "PLL标准算法 - 概率1/18", imageName: "pll_5"),
            Formula(name: "PLL Ab", category: .pll, algorithm: "x' (R U' R' D) (R U R' D') (R U R' D) (R U' R' D') x", description: "PLL标准算法 - 概率1/18", imageName: "pll_6"),
            Formula(name: "PLL E", category: .pll, algorithm: "R2 u (R' U R' U') R u' R2 y' (R' U R)", description: "PLL标准算法 - 概率1/36", imageName: "pll_7"),
            Formula(name: "PLL Ga", category: .pll, algorithm: "(F' U' F) (R2 u R' U) (R U' R u') R2'", description: "PLL标准算法 - 概率1/18", imageName: "pll_8"),
            Formula(name: "PLL Gb", category: .pll, algorithm: "y2 R2' F2 (R U2' R U2') R' F (R U R' U') R' F R2", description: "PLL标准算法 - 概率1/18", imageName: "pll_9"),
            Formula(name: "PLL Gc", category: .pll, algorithm: "(R U R') y' (R2 u' R U') (R' U R' u) R2", description: "PLL标准算法 - 概率1/18", imageName: "pll_10"),
            Formula(name: "PLL Gd", category: .pll, algorithm: "(R U' R' U') (R U R D) (R' U' R D') (R' U2 R') [U']", description: "PLL标准算法 - 概率1/18", imageName: "pll_11"),
            Formula(name: "PLL Ra", category: .pll, algorithm: "(R' U2 R U2') R' F (R U R' U') R' F' R2 [U']", description: "PLL标准算法 - 概率1/18", imageName: "pll_12"),
            Formula(name: "PLL Rb", category: .pll, algorithm: "(R' U L' U2) (R U' R' U2 R) L [U']", description: "PLL标准算法 - 概率1/18", imageName: "pll_13"),
            Formula(name: "PLL Ja", category: .pll, algorithm: "(R U R' F') (R U R' U') R' F R2 U' R' [U']", description: "PLL标准算法 - 概率1/18", imageName: "pll_14"),
            Formula(name: "PLL Jb", category: .pll, algorithm: "(R U R' U') (R' F R2 U') R' U' (R U R' F')", description: "PLL标准算法 - 概率1/18", imageName: "pll_15"),
            Formula(name: "PLL T", category: .pll, algorithm: "(R' U' F')(R U R' U')(R' F R2 U')(R' U' R U)(R' U R)", description: "PLL标准算法 - 概率1/18", imageName: "pll_16"),
            Formula(name: "PLL F", category: .pll, algorithm: "(R' U R' U') y (R' F' R2 U') (R' U R' F) R F", description: "PLL标准算法 - 概率1/18", imageName: "pll_17"),
            Formula(name: "PLL V", category: .pll, algorithm: "F (R U' R' U') (R U R' F') (R U R' U') (R' F R F')", description: "PLL标准算法 - 概率1/18", imageName: "pll_18"),
            Formula(name: "PLL Y", category: .pll, algorithm: "(RUR'U)(RUR'F')(RUR'U')(R'FR2U')R'U2(RU'R')", description: "PLL标准算法 - 概率1/18", imageName: "pll_19"),
            Formula(name: "PLL Na", category: .pll, algorithm: "(R' U R U') (R' F' U' F) (R U R' F) R' F' (R U' R)", description: "PLL标准算法 - 概率1/72", imageName: "pll_20"),
            Formula(name: "PLL Nb", category: .pll, algorithm: "x R2' D2 (R U R') D2 (R U' R) x'", description: "PLL标准算法 - 概率1/72", imageName: "pll_21"),
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
