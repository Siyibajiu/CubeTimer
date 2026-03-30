import Foundation

enum CFOPStage: String, CaseIterable, Codable {
    case cross = "Cross"
    case f2l = "F2L"
    case oll = "OLL"
    case pll = "PLL"
}

struct Formula: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: CFOPStage
    let algorithm: String
    let description: String
    let imageName: String?  // 可选的图片名称
    var isMastered: Bool = false
    var practiceCount: Int = 0
    var lastPracticed: Date?
}
