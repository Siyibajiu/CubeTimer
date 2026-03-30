import Foundation

class ScrambleGenerator {
    private let moves = ["R", "L", "U", "D", "F", "B"]
    private let modifiers = ["", "'", "2"]

    func generate(length: Int = 20) -> String {
        var scramble = [String]()
        var lastMove = ""

        for _ in 0..<length {
            var move: String
            var attempts = 0
            let maxAttempts = 100

            repeat {
                // 使用更安全的随机数生成方式
                let randomMoveIndex = Int.random(in: 0..<moves.count)
                let randomModifierIndex = Int.random(in: 0..<modifiers.count)
                let baseMove = moves[randomMoveIndex]
                let modifier = modifiers[randomModifierIndex]
                move = baseMove + modifier
                attempts += 1
            } while move.hasPrefix(lastMove) && attempts < maxAttempts

            scramble.append(move)
            lastMove = String(move.prefix(1))
        }

        return scramble.joined(separator: " ")
    }
}
