import Foundation

// MARK: - 时间范围枚举
enum TimeRange: String, CaseIterable {
    case week = "7天"
    case month = "30天"
    case quarter = "90天"
    case all = "全部"

    var days: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .all: return nil
        }
    }
}

// MARK: - 图表数据点
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let time: TimeInterval
    let solve: Solve?
}

// MARK: - 日统计数据
struct DailyStats: Identifiable {
    let id = UUID()
    let date: Date
    let averageTime: TimeInterval
    let count: Int
    let bestTime: TimeInterval
    let worstTime: TimeInterval
}

// MARK: - 图表数据
struct ChartData {
    let points: [ChartDataPoint]
    let dailyStats: [DailyStats]
    let timeRange: TimeRange

    var isEmpty: Bool {
        points.isEmpty
    }

    var bestTime: TimeInterval? {
        points.map { $0.time }.min()
    }

    var worstTime: TimeInterval? {
        points.map { $0.time }.max()
    }

    var averageTime: TimeInterval? {
        guard !points.isEmpty else { return nil }
        return points.reduce(0) { $0 + $1.time } / Double(points.count)
    }
}
