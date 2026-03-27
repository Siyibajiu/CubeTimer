import Foundation

class ScrambleGenerator {
    private let moves = ["R", "L", "U", "D", "F", "B"]
    private let modifiers = ["", "'", "2"]

    func generate(length: Int = 20) -> String {
        var scramble = [String]()
        var lastMove = ""

        for _ in 0..<length {
            var move: String

            repeat {
                let baseMove = moves.randomElement()!
                let modifier = modifiers.randomElement()!
                move = baseMove + modifier
            } while move.hasPrefix(lastMove)

            scramble.append(move)
            lastMove = String(move.prefix(1))
        }

        return scramble.joined(separator: " ")
    }
}
