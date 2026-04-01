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

    // 观察时间相关
    @Published var inspectionTime: Int = 15
    @Published var isInspecting = false
    @Published var isReadyAfterInspection = false
    private var inspectionTimer: Timer?

    init() {
        loadSolves()
        generateNewScramble()
    }

    func start() {
        guard !isRunning else { return }
        isReadyAfterInspection = false
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
    }

    // MARK: - 观察时间
    func startInspection() {
        guard !isRunning && !isInspecting else { return }
        isInspecting = true
        isReadyAfterInspection = false
        inspectionTime = 15

        inspectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.inspectionTime > 0 {
                self.inspectionTime -= 1
            } else {
                self.endInspection()
            }
        }
    }

    func endInspection() {
        isInspecting = false
        inspectionTimer?.invalidate()
        inspectionTimer = nil
        isReadyAfterInspection = true
    }

    func cancelInspection() {
        isInspecting = false
        inspectionTimer?.invalidate()
        inspectionTimer = nil
        isReadyAfterInspection = false
        inspectionTime = 15
    }

    func newScramble() {
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

        // 重置计时器和观察状态
        stop()
        currentTime = 0
        cancelInspection()
        generateNewScramble()
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

    func deleteSolve(_ solve: Solve) {
        if let index = solves.firstIndex(where: { $0.id == solve.id }) {
            solves.remove(at: index)
            saveSolves()
        }
    }

    // MARK: - 统计数据
    var pb: TimeInterval? {
        solves.map { $0.time }.min()
    }

    var ao5: TimeInterval? {
        guard solves.count >= 5 else { return nil }
        let recent5 = Array(solves.prefix(5))
        let times = recent5.map { $0.time }.sorted()
        let trimmed = times.dropFirst().dropLast()
        return trimmed.reduce(0, +) / Double(trimmed.count)
    }

    var ao12: TimeInterval? {
        guard solves.count >= 12 else { return nil }
        let recent12 = Array(solves.prefix(12))
        let times = recent12.map { $0.time }.sorted()
        let trimmed = times.dropFirst().dropLast()
        return trimmed.reduce(0, +) / Double(trimmed.count)
    }

    var average: TimeInterval? {
        guard !solves.isEmpty else { return nil }
        return solves.reduce(0) { $0 + $1.time } / Double(solves.count)
    }

    // MARK: - 练习活跃度数据
    func getSolvesByDay() -> [String: [Solve]] {
        let calendar = Calendar.current
        var daySolves: [String: [Solve]] = [:]

        for solve in solves {
            let dayKey = calendar.startOfDay(for: solve.date)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current  // 确保使用当前时区
            let dayString = formatter.string(from: dayKey)

            if daySolves[dayString] == nil {
                daySolves[dayString] = []
            }
            daySolves[dayString]?.append(solve)
        }

        return daySolves
    }

    func getSolvesForDate(_ date: Date) -> [Solve] {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let targetString = formatter.string(from: targetDay)

        let daySolves = getSolvesByDay()
        return daySolves[targetString] ?? []
    }

    // MARK: - 图表数据
    func getChartData(for range: TimeRange) -> ChartData {
        let filteredSolves = filterSolves(by: range)

        // 转换为数据点
        let points = filteredSolves.map { solve in
            ChartDataPoint(date: solve.date, time: solve.time, solve: solve)
        }

        // 计算日统计数据
        let dailyStats = calculateDailyStats(from: filteredSolves)

        return ChartData(points: points, dailyStats: dailyStats, timeRange: range)
    }

    private func filterSolves(by range: TimeRange) -> [Solve] {
        guard let days = range.days else {
            return solves.sorted { $0.date > $1.date }
        }

        let calendar = Calendar.current
        let cutoffDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        return solves.filter { $0.date >= cutoffDate }.sorted { $0.date > $1.date }
    }

    private func calculateDailyStats(from solves: [Solve]) -> [DailyStats] {
        let calendar = Calendar.current
        var dailyData: [String: [Solve]] = [:]

        // 按日期分组
        for solve in solves {
            let dayKey = calendar.startOfDay(for: solve.date)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current
            let dayString = formatter.string(from: dayKey)

            if dailyData[dayString] == nil {
                dailyData[dayString] = []
            }
            dailyData[dayString]?.append(solve)
        }

        // 转换为DailyStats
        return dailyData.compactMap { (dayString, daySolves) -> DailyStats? in
            guard !daySolves.isEmpty else { return nil }

            let times = daySolves.map { $0.time }
            let avg = times.reduce(0, +) / Double(times.count)
            let best = times.min() ?? 0
            let worst = times.max() ?? 0

            // 取第一条的日期作为代表
            let representativeDate = daySolves.first?.date ?? Date()

            return DailyStats(
                date: representativeDate,
                averageTime: avg,
                count: daySolves.count,
                bestTime: best,
                worstTime: worst
            )
        }.sorted { $0.date > $1.date }
    }
}
