import Foundation

// OLL (Orientation of Last Layer) - 57 个标准算法
// 从 Speedsolving Wiki 提取 (https://www.speedsolving.com/wiki/index.php/OLL)

class OLLData {
    static let shared = OLLData()

    private static let allFormulas: [Formula] = [
        Formula(name: "OLL 1 (Dot)", category: .oll, algorithm: "R U2' R2' F R F' U2 R' F R F'", imageName: "oll_1", rotation: 0),
        Formula(name: "OLL 2 (Dot)", category: .oll, algorithm: "(U') R U' R2' D' r U r' D R2 U R", imageName: "oll_2", rotation: 0),
        Formula(name: "OLL 3 (Dot)", category: .oll, algorithm: "(U) f (R U R' U') f' U' F (R U R' U') F'", imageName: "oll_3", rotation: 0),
        Formula(name: "OLL 4 (Dot)", category: .oll, algorithm: "f R U R' U' f' U F R U R' U' F'", imageName: "oll_4", rotation: 0),
        Formula(name: "OLL 5 (S)", category: .oll, algorithm: "(U2) l' U2 L U L' U l", imageName: "oll_5", rotation: 0),
        Formula(name: "OLL 6 (S)", category: .oll, algorithm: "(U2) r U2 R' U' R U' r'", imageName: "oll_6", rotation: 0),
        Formula(name: "OLL 7 (Small Bolt)", category: .oll, algorithm: "r U R' U R U2 r'", imageName: "oll_7", rotation: 0),
        Formula(name: "OLL 8 (Small Bolt)", category: .oll, algorithm: "l' U' L U' L' U2 l", imageName: "oll_8", rotation: 0),
        Formula(name: "OLL 9 (Fish)", category: .oll, algorithm: "(U') R U R' U' R' F R2 U R' U' F'", imageName: "oll_9", rotation: 0),
        Formula(name: "OLL 10 (Fish)", category: .oll, algorithm: "(U') R U R' U R' F R F' R U2' R'", imageName: "oll_10", rotation: 0),
        Formula(name: "OLL 11 (Small Bolt)", category: .oll, algorithm: "(U') r' R2 U R' U R U2' R' U M'", imageName: "oll_11", rotation: 0),
        Formula(name: "OLL 12 (Small Bolt)", category: .oll, algorithm: "(U') r R2' U' R U' R' U2 R U' r' R", imageName: "oll_12", rotation: 0),
        Formula(name: "OLL 13 (Knight)", category: .oll, algorithm: "F U R U2' R' U' R U R' F'", imageName: "oll_13", rotation: 0),
        Formula(name: "OLL 14 (Knight)", category: .oll, algorithm: "R' F R U R' F' R F U' F'", imageName: "oll_14", rotation: 0),
        Formula(name: "OLL 15 (Knight)", category: .oll, algorithm: "(U2) l' U' l L' U' L U l' U l", imageName: "oll_15", rotation: 0),
        Formula(name: "OLL 16 (Knight)", category: .oll, algorithm: "(U2) r U r' R U R' U' r U' r'", imageName: "oll_16", rotation: 0),
        Formula(name: "OLL 17 (Dot)", category: .oll, algorithm: "R U R' U R' F R F' U2 R' F R F'", imageName: "oll_17", rotation: 0),
        Formula(name: "OLL 18 (Dot)", category: .oll, algorithm: "R U2 R2 F R F' U2 M' U R U' r'", imageName: "oll_18", rotation: 0),
        Formula(name: "OLL 19 (Dot)", category: .oll, algorithm: "S' R U R' S U' R' F R F'", imageName: "oll_19", rotation: 0),
        Formula(name: "OLL 20 (Dot)", category: .oll, algorithm: "r' R U R U R' U' r R' M' U R U' r'", imageName: "oll_20", rotation: 0),
        Formula(name: "OLL 21 (OCLL)", category: .oll, algorithm: "R U R' U R U' R' U R U2 R'", imageName: "oll_21", rotation: 0),
        Formula(name: "OLL 22 (OCLL)", category: .oll, algorithm: "R U2' R2' U' R2 U' R2' U2' R", imageName: "oll_22", rotation: 0),
        Formula(name: "OLL 23 (OCLL)", category: .oll, algorithm: "R2' D' R U2 R' D R U2 R", imageName: "oll_23", rotation: 0),
        Formula(name: "OLL 24 (OCLL)", category: .oll, algorithm: "r U R' U' r' F R F'", imageName: "oll_24", rotation: 0),
        Formula(name: "OLL 25 (OCLL)", category: .oll, algorithm: "(U2) F R' F' r U R U' r'", imageName: "oll_25", rotation: 0),
        Formula(name: "OLL 26 (OCLL)", category: .oll, algorithm: "(y') R U2 R' U' R U' R'", imageName: "oll_26", rotation: 0),
        Formula(name: "OLL 27 (OCLL)", category: .oll, algorithm: "R U R' U R U2' R'", imageName: "oll_27", rotation: 0),
        Formula(name: "OLL 28 (E)", category: .oll, algorithm: "r U R' U' r' R U R U' R'", imageName: "oll_28", rotation: 0),
        Formula(name: "OLL 29 (Awkward)", category: .oll, algorithm: "(U) R U R' U' R U' R' F' U' F R U R'", imageName: "oll_29", rotation: 0),
        Formula(name: "OLL 30 (Awkward)", category: .oll, algorithm: "(U2) F U R U2' R' U' R U2 R' U' F'", imageName: "oll_30", rotation: 0),
        Formula(name: "OLL 31 (P)", category: .oll, algorithm: "(U2) R' U' F U R U' R' F' R", imageName: "oll_31", rotation: 0),
        Formula(name: "OLL 32 (P)", category: .oll, algorithm: "S R U R' U' R' F R f'", imageName: "oll_32", rotation: 0),
        Formula(name: "OLL 33 (T)", category: .oll, algorithm: "R U R' U' R' F R F'", imageName: "oll_33", rotation: 0),
        Formula(name: "OLL 34 (C)", category: .oll, algorithm: "R U R2' U' R' F R U R U' F'", imageName: "oll_34", rotation: 0),
        Formula(name: "OLL 35 (Fish)", category: .oll, algorithm: "R U2' R2' F R F' R U2' R'", imageName: "oll_35", rotation: 0),
        Formula(name: "OLL 36 (W)", category: .oll, algorithm: "(U2) L' U' L U' L' U L U L F' L' F", imageName: "oll_36", rotation: 0),
        Formula(name: "OLL 37 (Fish)", category: .oll, algorithm: "(U) F R' F' R U R U' R'", imageName: "oll_37", rotation: 0),
        Formula(name: "OLL 38 (W)", category: .oll, algorithm: "(U2) R U R' U R U' R' U' R' F R F'", imageName: "oll_38", rotation: 0),
        Formula(name: "OLL 39 (Big Bolt)", category: .oll, algorithm: "L F' L' U' L U F U' L'", imageName: "oll_39", rotation: 0),
        Formula(name: "OLL 40 (Big Bolt)", category: .oll, algorithm: "R' F R U R' U' F' U R", imageName: "oll_40", rotation: 0),
        Formula(name: "OLL 41 (Awkward)", category: .oll, algorithm: "(U2) R U R' U R U2 R' F R U R' U' F'", imageName: "oll_41", rotation: 0),
        Formula(name: "OLL 42 (Awkward)", category: .oll, algorithm: "R' U' R U' R' U2' R F R U R' U' F'", imageName: "oll_42", rotation: 0),
        Formula(name: "OLL 43 (P)", category: .oll, algorithm: "(U) R' U' F' U F R", imageName: "oll_43", rotation: 0),
        Formula(name: "OLL 44 (P)", category: .oll, algorithm: "(U2) F (U R U' R') F'", imageName: "oll_44", rotation: 0),
        Formula(name: "OLL 45 (T)", category: .oll, algorithm: "F R U R' U' F'", imageName: "oll_45", rotation: 0),
        Formula(name: "OLL 46 (C)", category: .oll, algorithm: "R' U' R' F R F' U R", imageName: "oll_46", rotation: 0),
        Formula(name: "OLL 47 (L)", category: .oll, algorithm: "(U') F R' F' R U2 R U' R' U R U2' R'", imageName: "oll_47", rotation: 0),
        Formula(name: "OLL 48 (L)", category: .oll, algorithm: "F R U R' U' R U R' U' F'", imageName: "oll_48", rotation: 0),
        Formula(name: "OLL 49 (L)", category: .oll, algorithm: "(U2) r U' r2' U r2 U r2' U' r", imageName: "oll_49", rotation: 0),
        Formula(name: "OLL 50 (L)", category: .oll, algorithm: "(U2) R' F R2 B' R2' F' R2 B R'", imageName: "oll_50", rotation: 0),
        Formula(name: "OLL 51 (I)", category: .oll, algorithm: "F U R U' R' U R U' R' F'", imageName: "oll_51", rotation: 0),
        Formula(name: "OLL 52 (I)", category: .oll, algorithm: "R U R' U R U' B U' B' R'", imageName: "oll_52", rotation: 0),
        Formula(name: "OLL 53 (L)", category: .oll, algorithm: "l' U' L U' L' U L U' L' U2 l", imageName: "oll_53", rotation: 0),
        Formula(name: "OLL 54 (L)", category: .oll, algorithm: "r U R' U R U' R' U R U2' r'", imageName: "oll_54", rotation: 0),
        Formula(name: "OLL 55 (I)", category: .oll, algorithm: "(U) R' F R U R U' R2' F' R2 U' R' U R U R'", imageName: "oll_55", rotation: 0),
        Formula(name: "OLL 56 (I)", category: .oll, algorithm: "r U r' U R U' R' U R U' R' r U' r'", imageName: "oll_56", rotation: 0),
        Formula(name: "OLL 57 (E)", category: .oll, algorithm: "R U R' U' M' U R U' r'", imageName: "oll_57", rotation: 0),
    ]

    private init() {}

    func getAllFormulas() -> [Formula] {
        return Self.allFormulas
    }

    func getFormulasByCategory() -> [String: [Formula]] {
        var grouped: [String: [Formula]] = [
            "OCLL (棱块已定向)": [],
            "Dot (无棱块定向)": [],
            "S 形状": [],
            "大闪电形状": [],
            "小闪电形状": [],
            "鱼形": [],
            "马步形": [],
            "Awkward 形状": [],
            "P 形状": [],
            "W 形状": [],
            "L 形状": [],
            "C 形状": [],
            "T 形状": [],
            "I 形状": [],
            "E 形状 (角块已定向)": [],
        ]

        for formula in Self.allFormulas {
            let name = formula.name

            switch name {
            case let s where s.contains("(OCLL)"):
                grouped["OCLL (棱块已定向)"]?.append(formula)
            case let s where s.contains("(Dot)"):
                grouped["Dot (无棱块定向)"]?.append(formula)
            case let s where s.contains("(S)"):
                grouped["S 形状"]?.append(formula)
            case let s where s.contains("(Big Bolt)"):
                grouped["大闪电形状"]?.append(formula)
            case let s where s.contains("(Small Bolt)"):
                grouped["小闪电形状"]?.append(formula)
            case let s where s.contains("(Fish)"):
                grouped["鱼形"]?.append(formula)
            case let s where s.contains("(Knight)"):
                grouped["马步形"]?.append(formula)
            case let s where s.contains("(Awkward)"):
                grouped["Awkward 形状"]?.append(formula)
            case let s where s.contains("(P)"):
                grouped["P 形状"]?.append(formula)
            case let s where s.contains("(W)"):
                grouped["W 形状"]?.append(formula)
            case let s where s.contains("(L)"):
                grouped["L 形状"]?.append(formula)
            case let s where s.contains("(C)"):
                grouped["C 形状"]?.append(formula)
            case let s where s.contains("(T)"):
                grouped["T 形状"]?.append(formula)
            case let s where s.contains("(I)"):
                grouped["I 形状"]?.append(formula)
            case let s where s.contains("(E)"):
                grouped["E 形状 (角块已定向)"]?.append(formula)
            default:
                break
            }
        }

        return grouped
    }
}
