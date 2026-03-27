import Foundation

class FormulaData {
    static let shared = FormulaData()

    private init() {}

    func getAllFormulas() -> [Formula] {
        return [
            // Cross 公式
            Formula(name: "F2", category: .cross, algorithm: "F2", description: "白色棱块在前面顶层位置，需要直接转到底层"),
            Formula(name: "R' F R", category: .cross, algorithm: "R' F R", description: "白色棱块在顶层右前位置，需要插入到前底层"),
            Formula(name: "R' F R F'", category: .cross, algorithm: "R' F R F'", description: "棱块在正确位置但方向错误（白色朝侧面）"),
            Formula(name: "U R' F R", category: .cross, algorithm: "U R' F R", description: "棱块和目标位置不在同一面"),

            // F2L 公式
            Formula(name: "基础配对", category: .f2l, algorithm: "U R U' R'", description: "最简单的情况，角块和棱块已经在顶层配对"),
            Formula(name: "隐藏配对", category: .f2l, algorithm: "R U R' U' R U R'", description: "隐藏角块，带出棱块进行配对"),
            Formula(name: "底层提取", category: .f2l, algorithm: "R U R'", description: "角块在底层槽位中，需要先带到顶层再配对"),

            // OLL 公式
            Formula(name: "一字型", category: .oll, algorithm: "F R U R' U' F'", description: "从点变成小拐杖"),
            Formula(name: "小拐杖", category: .oll, algorithm: "F R U R' U' F'", description: "从小拐杖变成一字型"),
            Formula(name: "十字公式", category: .oll, algorithm: "F R U R' U' F'", description: "一次完成十字"),
            Formula(name: "小鱼公式1", category: .oll, algorithm: "R U R' U R U2 R'", description: "顶面左侧有小鱼形状，逆时针方向"),
            Formula(name: "小鱼公式2", category: .oll, algorithm: "R U2 R' U' R U' R'", description: "顶面右侧有小鱼形状，顺时针方向"),

            // PLL 公式
            Formula(name: "U-perm", category: .pll, algorithm: "R U R' F' R U R' U' R' F R2 U' R'", description: "顶层角块顺时针交换"),
            Formula(name: "T-perm", category: .pll, algorithm: "R U R' U' R' F R2 U' R' U' R U R' F'", description: "交换相邻角块和棱块"),
            Formula(name: "J-perm", category: .pll, algorithm: "R' U L' U2 R U' R' U2 R L", description: "交换右侧角块和棱块"),
        ]
    }
}
