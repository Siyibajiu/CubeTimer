import Foundation

enum CFOPStage: String, CaseIterable, Codable {
    case f2l = "F2L"
    case oll = "OLL"
    case pll = "PLL"
}

struct Formula: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: CFOPStage
    let algorithm: String
    let imageName: String?  // 可选的图片名称
    let rotation: Double      // 图片旋转角度（0, 90, 180, 270）
    let isAlternative: Bool = false  // 是否为替代算法
    let alternativeCount: Int = 0    // 该案例有多少个替代算法（包括自己）
}

// 练习进度数据（单独存储）
struct FormulaPractice: Codable {
    let formulaId: UUID
    var isMastered: Bool = false
    var practiceCount: Int = 0
    var lastPracticed: Date?
    var hasError: Bool = false  // 错误标记
}
