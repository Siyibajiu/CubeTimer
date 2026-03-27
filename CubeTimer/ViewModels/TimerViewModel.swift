import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var solves: [Solve] = []

    private var timer: Timer?
    private var startTime: Date?
    private let scrambler = ScrambleGenerator()
    @Published var currentScramble = ""

    init() {
        loadSolves()
        generateNewScramble()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if let start = self.startTime {
                self.currentTime = Date().timeIntervalSince(start)
            }
        }
    }

    func stop() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil

        // 自动保存成绩
        if currentTime > 0 {
            let solve = Solve(date: Date(), time: currentTime, scramble: currentScramble)
            solves.insert(solve, at: 0)
            saveSolves()
        }
    }

    func reset() {
        stop()
        currentTime = 0
        generateNewScramble()
    }

    func saveSolve() {
        guard currentTime > 0 else { return }

        // 创建成绩记录
        let solve = Solve(
            date: Date(),
            time: currentTime,
            scramble: currentScramble
        )

        // 添加到列表
        solves.insert(solve, at: 0)

        // 保存到UserDefaults
        saveSolves()

        // 重置计时器
        reset()
    }

    func generateNewScramble() {
        currentScramble = scrambler.generate()
    }

    func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%02d:%05.2f", minutes, seconds)
    }

    // MARK: - 数据持久化
    private func saveSolves() {
        if let data = try? JSONEncoder().encode(solves) {
            UserDefaults.standard.set(data, forKey: "solves")
        }
    }

    private func loadSolves() {
        if let data = UserDefaults.standard.data(forKey: "solves"),
           let decoded = try? JSONDecoder().decode([Solve].self, from: data) {
            solves = decoded
        }
    }

    func getRank(for solve: Solve) -> Int {
        return (solves.firstIndex(where: { $0.id == solve.id }) ?? 0) + 1
    }
}
