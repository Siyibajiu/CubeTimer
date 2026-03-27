import Foundation

enum CFOPStage: String, CaseIterable {
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
}
