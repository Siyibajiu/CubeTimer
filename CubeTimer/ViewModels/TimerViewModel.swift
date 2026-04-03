import Foundation
import Combine
import UIKit

class TimerViewModel: ObservableObject {
    @Published var currentTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var solves: [Solve] = []

    private var timer: Timer?
    private var startTime: Date?
    private let scrambler = ScrambleGenerator()
    @Published var currentScramble = ""

    // 专项计时类型
    @Published var selectedCategory: CFOPStage? = nil  // nil 表示完整还原

    // 观察时间相关
    @Published var inspectionTime: Int = 15
    @Published var isInspecting = false
    @Published var isReadyAfterInspection = false
    private var inspectionTimer: Timer?

    // 复用DateFormatter，避免重复创建
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    // 缓存统计数据
    private var cachedAO5: TimeInterval?
    private var cachedAO5Solves: [Solve]?
    private var cachedAO12: TimeInterval?
    private var cachedAO12Solves: [Solve]?

    // Debounce 订阅，用于延迟写入
    private var saveCancellable: AnyCancellable?
    private let saveDebounceInterval: TimeInterval = 1.0 // 1秒延迟

    init() {
        generateNewScramble()
        loadSolves()
        setupDebounceSave()

        // 监听 App 生命周期事件
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveBeforeTerminate),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 设置延迟保存
    private func setupDebounceSave() {
        saveCancellable = $solves
            .debounce(for: .seconds(saveDebounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveSolves()
            }
    }

    // App 进入后台时立即保存
    @objc private func saveBeforeTerminate() {
        saveSolves()
    }

    func start() {
        guard !isRunning else { return }
        isReadyAfterInspection = false
        isRunning = true
        startTime = Date()

        // 使用 100ms 的 UI 更新间隔，平衡显示流畅度和性能
        // 计时仍然准确（基于 Date() 计算），只是显示更新频率降低
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            self.currentTime = Date().timeIntervalSince(start)
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

        // 创建成绩记录，包含专项类型
        let solve = Solve(
            date: Date(),
            time: currentTime,
            scramble: currentScramble,
            category: selectedCategory  // 记录当前选择的分类
        )

        // 添加到列表
        solves.insert(solve, at: 0)

        // 移除直接保存，由 debounce 自动处理

        // 重置计时器和观察状态
        stop()
        currentTime = 0
        cancelInspection()
        generateNewScramble()
    }

    // 根据分类筛选成绩
    func filteredSolves(for category: CFOPStage?) -> [Solve] {
        if let category = category {
            return solves.filter { $0.category == category }
        } else {
            return solves.filter { $0.category == nil }
        }
    }

    // 获取当前分类的 PB
    func pb(for category: CFOPStage?) -> TimeInterval? {
        filteredSolves(for: category).map { $0.time }.min()
    }

    // 获取当前分类的 AO5
    func ao5(for category: CFOPStage?) -> TimeInterval? {
        let filtered = filteredSolves(for: category)
        guard filtered.count >= 5 else { return nil }

        let recent5 = Array(filtered.prefix(5))
        let times = recent5.map { $0.time }.sorted()
        let trimmed = times.dropFirst().dropLast()
        return trimmed.reduce(0, +) / Double(trimmed.count)
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
        // 完全异步加载数据，不阻塞
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var decoded: [Solve]?

            if let data = UserDefaults.standard.data(forKey: "solves") {
                decoded = try? JSONDecoder().decode([Solve].self, from: data)
            }

            // 在主线程更新 UI
            DispatchQueue.main.async {
                if let decoded = decoded {
                    self?.solves = decoded
                }
            }
        }
    }

    func getRank(for solve: Solve) -> Int {
        return (solves.firstIndex(where: { $0.id == solve.id }) ?? 0) + 1
    }

    func deleteSolve(_ solve: Solve) {
        if let index = solves.firstIndex(where: { $0.id == solve.id }) {
            solves.remove(at: index)
            // 移除直接保存，由 debounce 自动处理
        }
    }

    // MARK: - 数据导出/导入
    func exportData() -> URL? {
        guard !solves.isEmpty else { return nil }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(solves)

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsPath.appendingPathComponent("CubeTimer_Backup_\(Date().timeIntervalSince1970).json")

            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("导出失败: \(error)")
            return nil
        }
    }

    func importData(from url: URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Solve].self, from: data)

            // 合并数据，保留原有数据
            let existingIds = Set(solves.map { $0.id })
            let newSolves = decoded.filter { !existingIds.contains($0.id) }

            solves = newSolves + solves
            // 导入操作立即保存（重要操作）
            saveSolves()

            return true
        } catch {
            print("导入失败: \(error)")
            return false
        }
    }

    // MARK: - 统计数据（优化性能）
    var pb: TimeInterval? {
        solves.map { $0.time }.min()
    }

    var ao5: TimeInterval? {
        guard solves.count >= 5 else { return nil }

        // 检查缓存
        if let cached = cachedAO5,
           let cachedSolves = cachedAO5Solves,
           Array(solves.prefix(5)) == cachedSolves {
            return cached
        }

        // 计算AO5
        let recent5 = Array(solves.prefix(5))
        let times = recent5.map { $0.time }.sorted()
        let trimmed = times.dropFirst().dropLast()
        let result = trimmed.reduce(0, +) / Double(trimmed.count)

        // 更新缓存
        cachedAO5 = result
        cachedAO5Solves = recent5

        return result
    }

    var ao12: TimeInterval? {
        guard solves.count >= 12 else { return nil }

        // 检查缓存
        if let cached = cachedAO12,
           let cachedSolves = cachedAO12Solves,
           Array(solves.prefix(12)) == cachedSolves {
            return cached
        }

        // 计算AO12
        let recent12 = Array(solves.prefix(12))
        let times = recent12.map { $0.time }.sorted()
        let trimmed = times.dropFirst().dropLast()
        let result = trimmed.reduce(0, +) / Double(trimmed.count)

        // 更新缓存
        cachedAO12 = result
        cachedAO12Solves = recent12

        return result
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
            let dayString = dayFormatter.string(from: dayKey)

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
        let targetString = dayFormatter.string(from: targetDay)

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
            let dayString = dayFormatter.string(from: dayKey)

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
