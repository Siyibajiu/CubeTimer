import Foundation

struct Solve: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let time: TimeInterval // 秒
    let scramble: String
}
