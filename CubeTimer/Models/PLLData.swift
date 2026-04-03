import Foundation

// PLL (Permutation of Last Layer) - 21 个标准算法
// 从 Speedsolving Wiki 提取 (2026年最新版本)

class PLLData {
    static let shared = PLLData()

    private static let allFormulas: [Formula] = [
        // === PLL U 形状 - 2 个案例 ===
        Formula(name: "PLL Ua", category: .pll, algorithm: "R U R' U R' U' R2 U' R' U R' U R", imageName: "pll_ua", rotation: 0),
        Formula(name: "PLL Ub", category: .pll, algorithm: "R' U R' U' R' U R' U R U2 R' U' R U2", imageName: "pll_ub", rotation: 0),

        // === PLL Z 和 H 形状 ===
        Formula(name: "PLL Z", category: .pll, algorithm: "M2' U M2' U M' U2 M2' U2 M'", imageName: "pll_z", rotation: 0),
        Formula(name: "PLL H", category: .pll, algorithm: "M2' U M2' U2 M2' U M2'", imageName: "pll_h", rotation: 0),

        // === PLL A 形状 - 2 个案例 ===
        Formula(name: "PLL Aa", category: .pll, algorithm: "x R' U R' D2 R U' R' D2 R2 x'", imageName: "pll_aa", rotation: 0),
        Formula(name: "PLL Ab", category: .pll, algorithm: "x R2' D2 R U R' D2 R U' R x'", imageName: "pll_ab", rotation: 0),

        // === PLL E 形状 ===
        Formula(name: "PLL E", category: .pll, algorithm: "x' R U' R' D R U R' D' R U R' D R U' R' D' x", imageName: "pll_e", rotation: 0),

        // === PLL G 形状 - 4 个案例 ===
        Formula(name: "PLL Ga", category: .pll, algorithm: "R2' u (R' U R' U' R) u' R2 y' (R' U R)", imageName: "pll_ga", rotation: 0),
        Formula(name: "PLL Gb", category: .pll, algorithm: "R' U' R y R2 u (R' U R U' R) u' R2", imageName: "pll_gb", rotation: 0),
        Formula(name: "PLL Gc", category: .pll, algorithm: "y' R2 F2 R U2 R U2 R' F R U R' U' R' F R2", imageName: "pll_gc", rotation: 0),
        Formula(name: "PLL Gd", category: .pll, algorithm: "y2 R U R' y' R2 u' (R U' R' U R') u R2", imageName: "pll_gd", rotation: 0),

        // === PLL R 形状 - 2 个案例 ===
        Formula(name: "PLL Ra", category: .pll, algorithm: "y' R U' R' U' R U R D R' U' R D' R' U2 R'", imageName: "pll_ra", rotation: 0),
        Formula(name: "PLL Rb", category: .pll, algorithm: "R' U2 R U2 R' F R U R' U' R' F' R2", imageName: "pll_rb", rotation: 0),

        // === PLL J 形状 - 2 个案例 ===
        Formula(name: "PLL Ja", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R' U'", imageName: "pll_ja", rotation: 0),
        Formula(name: "PLL Jb", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R' U'", imageName: "pll_jb", rotation: 0),

        // === PLL T 形状 ===
        Formula(name: "PLL T", category: .pll, algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'", imageName: "pll_t", rotation: 0),

        // === PLL F 形状 ===
        Formula(name: "PLL F", category: .pll, algorithm: "y R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R", imageName: "pll_f", rotation: 0),

        // === PLL V 和 Y 形状 ===
        Formula(name: "PLL V", category: .pll, algorithm: "y R U' R U R' D R D' R U' D R2 U R2 D' R2", imageName: "pll_v", rotation: 0),
        Formula(name: "PLL Y", category: .pll, algorithm: "F R U' R' U' R U R' F' (R U R' U') (R' F R F')", imageName: "pll_y", rotation: 0),

        // === PLL N 形状 - 2 个案例 ===
        Formula(name: "PLL Na", category: .pll, algorithm: "R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'", imageName: "pll_na", rotation: 0),
        Formula(name: "PLL Nb", category: .pll, algorithm: "(R' U L' U2 R U' L)2 U", imageName: "pll_nb", rotation: 0),
    ]

    private init() {}

    func getAllFormulas() -> [Formula] {
        return Self.allFormulas
    }

    func getFormulasByType() -> [String: [Formula]] {
        var grouped: [String: [Formula]] = [
            "U 形状": [],
            "Z/H": [],
            "A 形状": [],
            "E 形状": [],
            "G 形状": [],
            "R 形状": [],
            "J 形状": [],
            "T 形状": [],
            "F 形状": [],
            "V/Y": [],
            "N 形状": []
        ]

        for formula in Self.allFormulas {
            let name = formula.name

            switch name {
            case let s where s.hasPrefix("PLL U"):
                grouped["U 形状"]?.append(formula)
            case let s where s == "PLL Z" || s == "PLL H":
                grouped["Z/H"]?.append(formula)
            case let s where s.hasPrefix("PLL A"):
                grouped["A 形状"]?.append(formula)
            case let s where s == "PLL E":
                grouped["E 形状"]?.append(formula)
            case let s where s.hasPrefix("PLL G"):
                grouped["G 形状"]?.append(formula)
            case let s where s.hasPrefix("PLL R"):
                grouped["R 形状"]?.append(formula)
            case let s where s.hasPrefix("PLL J"):
                grouped["J 形状"]?.append(formula)
            case let s where s == "PLL T":
                grouped["T 形状"]?.append(formula)
            case let s where s == "PLL F":
                grouped["F 形状"]?.append(formula)
            case let s where s == "PLL V" || s == "PLL Y":
                grouped["V/Y"]?.append(formula)
            case let s where s.hasPrefix("PLL N"):
                grouped["N 形状"]?.append(formula)
            default:
                break
            }
        }

        return grouped
    }
}
