import Foundation

struct Solve: Identifiable, Codable, Equatable {
    let id = UUID()
    let date: Date
    let time: TimeInterval // 秒
    let scramble: String
    let category: CFOPStage?  // 专项计时类型，nil 表示完整还原
}
