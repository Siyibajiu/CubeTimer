import Foundation

// F2L (First Two Layers) - 41 个标准算法
// 从 Speed Cube Database 和 CubeSkills 提取

class F2LData {
    static let shared = F2LData()

    private static let allFormulas: [Formula] = [
        // === F2L 案例 1-10: 基础案例 ===
        Formula(name: "F2L Case 1", category: .f2l, algorithm: "U (R U' R')", imageName: "f2l_1", rotation: 0),
        Formula(name: "F2L Case 2", category: .f2l, algorithm: "y' U' (R' U R)", imageName: "f2l_2", rotation: 0),
        Formula(name: "F2L Case 3", category: .f2l, algorithm: "y' (R' U' R)", imageName: "f2l_3", rotation: 0),
        Formula(name: "F2L Case 4", category: .f2l, algorithm: "(R U R')", imageName: "f2l_4", rotation: 0),
        Formula(name: "F2L Case 5", category: .f2l, algorithm: "U' (R U' R' U) y' (R' U' R)", imageName: "f2l_5", rotation: 0),
        Formula(name: "F2L Case 6", category: .f2l, algorithm: "U' (R U R' U) (R U R')", imageName: "f2l_6", rotation: 0),
        Formula(name: "F2L Case 7", category: .f2l, algorithm: "U' (R U2' R' U) y' (R' U' R)", imageName: "f2l_7", rotation: 0),
        Formula(name: "F2L Case 8", category: .f2l, algorithm: "R' U2' R2 U R2' U R", imageName: "f2l_8", rotation: 0),
        Formula(name: "F2L Case 9", category: .f2l, algorithm: "y' U (R' U R U') (R' U' R)", imageName: "f2l_9", rotation: 0),
        Formula(name: "F2L Case 10", category: .f2l, algorithm: "U' (R U' R' U) (R U R')", imageName: "f2l_10", rotation: 0),

        // === F2L 案例 11-20: 中等难度 ===
        Formula(name: "F2L Case 11", category: .f2l, algorithm: "(U' R U R') U2 (R U' R')", imageName: "f2l_11", rotation: 0),
        Formula(name: "F2L Case 12", category: .f2l, algorithm: "y' (U R' U' R) U2' (R' U R)", imageName: "f2l_12", rotation: 0),
        Formula(name: "F2L Case 13", category: .f2l, algorithm: "U' (R U2' R') U2 (R U' R')", imageName: "f2l_13", rotation: 0),
        Formula(name: "F2L Case 14", category: .f2l, algorithm: "y' U (R' U2 R) U2' (R' U R)", imageName: "f2l_14", rotation: 0),
        Formula(name: "F2L Case 15", category: .f2l, algorithm: "U (R U2 R') U (R U' R')", imageName: "f2l_15", rotation: 0),
        Formula(name: "F2L Case 16", category: .f2l, algorithm: "y' U' (R' U2 R) U' (R' U R)", imageName: "f2l_16", rotation: 0),
        Formula(name: "F2L Case 17", category: .f2l, algorithm: "U2 (R U R' U) (R U' R')", imageName: "f2l_17", rotation: 0),
        Formula(name: "F2L Case 18", category: .f2l, algorithm: "y' U2 (R' U' R) U' (R' U R)", imageName: "f2l_18", rotation: 0),
        Formula(name: "F2L Case 19", category: .f2l, algorithm: "y' (R' U R) U2' y (R U R')", imageName: "f2l_19", rotation: 0),
        Formula(name: "F2L Case 20", category: .f2l, algorithm: "(R U' R' U2) y' (R' U' R)", imageName: "f2l_20", rotation: 0),

        // === F2L 案例 21-30: 高级案例 ===
        Formula(name: "F2L Case 21", category: .f2l, algorithm: "F (U R U' R') F' (R U' R')", imageName: "f2l_21", rotation: 0),
        Formula(name: "F2L Case 22", category: .f2l, algorithm: "R' F' R U (R U' R') F", imageName: "f2l_22", rotation: 0),
        Formula(name: "F2L Case 23", category: .f2l, algorithm: "U (R U' R') (F R' F' R)", imageName: "f2l_23", rotation: 0),
        Formula(name: "F2L Case 24", category: .f2l, algorithm: "(R U' R' U) (R U' R')", imageName: "f2l_24", rotation: 0),
        Formula(name: "F2L Case 25", category: .f2l, algorithm: "y' (R' U R U') (R' U R)", imageName: "f2l_25", rotation: 0),
        Formula(name: "F2L Case 26", category: .f2l, algorithm: "(R' F R F') U (R U' R')", imageName: "f2l_26", rotation: 0),
        Formula(name: "F2L Case 27", category: .f2l, algorithm: "(R U R' U') (R U R')", imageName: "f2l_27", rotation: 0),
        Formula(name: "F2L Case 28", category: .f2l, algorithm: "U' (R' F R F') (R U' R')", imageName: "f2l_28", rotation: 0),
        Formula(name: "F2L Case 29", category: .f2l, algorithm: "(U R U' R') (U R U' R') (U R U' R')", imageName: "f2l_29", rotation: 0),
        Formula(name: "F2L Case 30", category: .f2l, algorithm: "(U' R U' R') U2 (R U' R')", imageName: "f2l_30", rotation: 0),

        // === F2L 案例 31-41: 复杂案例 ===
        Formula(name: "F2L Case 31", category: .f2l, algorithm: "U (R U R') U2 (R U R')", imageName: "f2l_31", rotation: 0),
        Formula(name: "F2L Case 32", category: .f2l, algorithm: "(U' R U R') U y' (R' U' R)", imageName: "f2l_32", rotation: 0),
        Formula(name: "F2L Case 33", category: .f2l, algorithm: "U (F' U' F) U' (R U R')", imageName: "f2l_33", rotation: 0),
        Formula(name: "F2L Case 34", category: .f2l, algorithm: "R U R' (已配对)", imageName: "f2l_34", rotation: 0),
        Formula(name: "F2L Case 35", category: .f2l, algorithm: "(R U' R') d (R' U2 R) U2' (R' U R)", imageName: "f2l_35", rotation: 0),
        Formula(name: "F2L Case 36", category: .f2l, algorithm: "(R U R' U') R U2 R' U' (R U R')", imageName: "f2l_36", rotation: 0),
        Formula(name: "F2L Case 37", category: .f2l, algorithm: "(R U R') U2' (R U' R' U) (R U R')", imageName: "f2l_37", rotation: 0),
        Formula(name: "F2L Case 38", category: .f2l, algorithm: "(F' U F) U2 (R U R' U) (R U' R')", imageName: "f2l_38", rotation: 0),
        Formula(name: "F2L Case 39", category: .f2l, algorithm: "(R U R' U') (R U' R') U2 y' (R' U' R)", imageName: "f2l_39", rotation: 0),
        Formula(name: "F2L Case 40", category: .f2l, algorithm: "R' U' R U R U' U R U R' U' R", imageName: "f2l_40", rotation: 0),
        Formula(name: "F2L Case 41", category: .f2l, algorithm: "R U R' U' R U R' U' R U R'", imageName: "f2l_41", rotation: 0),
    ]

    private init() {}

    func getAllFormulas() -> [Formula] {
        return Self.allFormulas
    }

    func getFormulasByDifficulty() -> [String: [Formula]] {
        var grouped: [String: [Formula]] = [
            "基础案例": [],
            "中等难度": [],
            "高级案例": [],
            "复杂案例": []
        ]

        for formula in Self.allFormulas {
            let caseNumber = extractCaseNumber(formula.name)

            switch caseNumber {
            case 1...10:
                grouped["基础案例"]?.append(formula)
            case 11...20:
                grouped["中等难度"]?.append(formula)
            case 21...30:
                grouped["高级案例"]?.append(formula)
            case 31...41:
                grouped["复杂案例"]?.append(formula)
            default:
                break
            }
        }

        return grouped
    }

    private func extractCaseNumber(_ name: String) -> Int {
        if let range = name.range(of: "Case \\d+", options: .regularExpression) {
            let numberString = String(name[range]).replacingOccurrences(of: "Case ", with: "")
            return Int(numberString) ?? 0
        }
        return 0
    }
}
