import SwiftUI

// 根据公式类型绘制魔方图案
struct CubePatternView: View {
    let formulaName: String
    let category: CFOPStage

    var body: some View {
        ZStack {
            // 背景色
            backgroundColor
                .opacity(0.2)

            // 根据公式绘制不同图案
            patternContent
        }
        .frame(height: 120)
        .cornerRadius(12)
    }

    private var backgroundColor: Color {
        switch category {
        case .cross: return .green
        case .f2l: return .blue
        case .oll: return .orange
        case .pll: return .purple
        }
    }

    @ViewBuilder
    private var patternContent: some View {
        if formulaName.contains("OLL") {
            OLLOneLayerPattern(type: getOLLType())
        } else if formulaName.contains("PLL") {
            PLLOneLayerPattern(type: getPLLType())
        } else if formulaName.contains("F2L") {
            F2LPattern()
        } else {
            CrossPattern()
        }
    }

    private func getOLLType() -> String {
        if formulaName.contains("小鱼") { return "fish" }
        if formulaName.contains("一字") { return "line" }
        if formulaName.contains("点") { return "point" }
        if formulaName.contains("T") { return "t" }
        return "default"
    }

    private func getPLLType() -> String {
        if formulaName.contains("T-perm") { return "t" }
        if formulaName.contains("Y-perm") { return "y" }
        if formulaName.contains("U") { return "u" }
        if formulaName.contains("H") { return "h" }
        if formulaName.contains("Z") { return "z" }
        if formulaName.contains("J") { return "j" }
        return "default"
    }
}

// OLL 顶层图案
struct OLLOneLayerPattern: View {
    let type: String

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.6
            VStack(spacing: 4) {
                ForEach(0..<3) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<3) { col in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(cellColor(row: row, col: col))
                                .frame(width: size/3, height: size/3)
                        }
                    }
                }
            }
            .frame(width: size, height: size)
        }
    }

    private func cellColor(row: Int, col: Int) -> Color {
        let centerColor = Color.orange

        switch type {
        case "fish":
            // 小鱼图案
            if row == 1 && col == 1 { return centerColor }
            if (row == 0 && col == 1) || (row == 1 && col == 0) { return Color.yellow }
            return Color.gray

        case "line":
            // 一字型
            if row == 1 { return Color.yellow }
            return Color.gray

        case "point":
            // 点状
            if row == 1 && col == 1 { return Color.yellow }
            return Color.gray

        case "t":
            // T字型
            if row == 0 || (row == 1 && col == 1) { return Color.yellow }
            return Color.gray

        default:
            // 默认十字
            if row == 1 || col == 1 { return Color.yellow }
            return Color.gray
        }
    }
}

// PLL 排列图案
struct PLLOneLayerPattern: View {
    let type: String

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.6
            VStack(spacing: 4) {
                ForEach(0..<3) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<3) { col in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(cellColor(row: row, col: col))
                                .frame(width: size/3, height: size/3)
                                .overlay(
                                    Text(letterAt(row: row, col: col))
                                        .font(.system(size: size/10))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
            }
            .frame(width: size, height: size)
        }
    }

    private func cellColor(row: Int, col: Int) -> Color {
        Color.yellow
    }

    private func letterAt(row: Int, col: Int) -> String {
        switch type {
        case "t":
            return "T"
        case "y":
            return "Y"
        case "u":
            return "U"
        case "h":
            return "H"
        case "z":
            return "Z"
        case "j":
            return "J"
        default:
            return ""
        }
    }
}

// F2L 图案
struct F2LPattern: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.5
            ZStack {
                // 角块
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue)
                    .frame(width: size/2, height: size/2)
                    .offset(x: -size/4, y: -size/4)

                // 棱块
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.red)
                    .frame(width: size/3, height: size/3)
                    .offset(x: size/4, y: size/4)

                Text("F2L")
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(y: size/2)
            }
            .frame(width: size, height: size)
        }
    }
}

// Cross 图案
struct CrossPattern: View {
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.6

            ZStack {
                // 中心块
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.green)
                    .frame(width: size/3, height: size/3)

                // 十字臂
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green)
                    .frame(width: size, height: size/4)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green)
                    .frame(width: size/4, height: size)

                Text("Cross")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
        }
    }
}
