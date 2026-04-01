import SwiftUI
import Charts

struct TrendChartView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var selectedRange: TimeRange = .month
    @State private var showDailyAverage = false

    private var chartData: ChartData {
        viewModel.getChartData(for: selectedRange)
    }

    var body: some View {
        VStack(spacing: 16) {
            // 标题和时间范围选择
            header

            if chartData.isEmpty {
                emptyState
            } else {
                // 图表
                chart

                // 统计摘要
                if !showDailyAverage {
                    summaryCards
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }

    // MARK: - 头部
    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Text("成绩趋势")
                    .font(.headline)
                    .bold()

                Spacer()

                // 数据模式切换
                Picker("Mode", selection: $showDailyAverage) {
                    Text("单次").tag(false)
                    Text("日均").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }

            // 时间范围选择
            Picker("Time Range", selection: $selectedRange) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - 图表
    private var chart: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showDailyAverage {
                // 日均折线图
                dailyAverageChart
            } else {
                // 单次成绩散点图+折线图
                singleSolveChart
            }
        }
        .frame(height: 200)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }

    // MARK: - 单次成绩图表
    private var singleSolveChart: some View {
        Chart {
            // 辅助线：PB
            if let pb = viewModel.pb {
                RuleMark(y: .value("PB", pb))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundStyle(.yellow)
                    .annotation(position: .top, spacing: 0) {
                        Text("PB")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
            }

            // 数据点
            ForEach(chartData.points) { point in
                LineMark(
                    x: .value("日期", point.date),
                    y: .value("用时", point.time)
                )
                .foregroundStyle(pointColor(for: point.time))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("日期", point.date),
                    y: .value("用时", point.time)
                )
                .foregroundStyle(pointColor(for: point.time))
                .annotation(position: .top) {
                    if let pb = viewModel.pb, point.time == pb {
                        Text("★")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel {
                    if let seconds = value.as(Double.self) {
                        Text(formatTime(seconds))
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic(desiredCount: 5)) { value in
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(formatShortDate(date))
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
    }

    // MARK: - 日均图表
    private var dailyAverageChart: some View {
        Chart {
            // 辅助线：总平均
            if let avg = chartData.averageTime {
                RuleMark(y: .value("平均", avg))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundStyle(.blue)
                    .annotation(position: .top, spacing: 0) {
                        Text("平均")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
            }

            // 日均柱状图
            ForEach(chartData.dailyStats) { stat in
                BarMark(
                    x: .value("日期", stat.date),
                    y: .value("平均用时", stat.averageTime)
                )
                .foregroundStyle(
                    averageColor(for: stat.averageTime)
                )
                .cornerRadius(4)
                .annotation(position: .top) {
                    if stat.count > 1 {
                        Text("×\(stat.count)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel {
                    if let seconds = value.as(Double.self) {
                        Text(formatTime(seconds))
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic(desiredCount: 5)) { value in
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(formatShortDate(date))
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
    }

    // MARK: - 统计摘要卡片
    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "总次数",
                value: "\(chartData.points.count)",
                color: .blue
            )

            SummaryCard(
                title: "最佳",
                value: chartData.bestTime.map { formatTime($0) } ?? "--",
                color: .green
            )

            SummaryCard(
                title: "平均",
                value: chartData.averageTime.map { formatTime($0) } ?? "--",
                color: .orange
            )

            SummaryCard(
                title: "最差",
                value: chartData.worstTime.map { formatTime($0) } ?? "--",
                color: .red
            )
        }
    }

    // MARK: - 空状态
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text("暂无数据")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("在\(selectedRange.rawValue)内还没有练习记录")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }

    // MARK: - 辅助方法
    private func pointColor(for time: TimeInterval) -> Color {
        guard let pb = viewModel.pb else { return .blue }
        let ratio = time / pb

        if ratio <= 1.1 {
            return .green
        } else if ratio <= 1.3 {
            return .orange
        } else {
            return .red
        }
    }

    private func averageColor(for time: TimeInterval) -> Color {
        guard let pb = viewModel.pb else { return .blue }
        let ratio = time / pb

        if ratio <= 1.1 {
            return .green.opacity(0.7)
        } else if ratio <= 1.3 {
            return .orange.opacity(0.7)
        } else {
            return .red.opacity(0.7)
        }
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)

        if minutes > 0 {
            return String(format: "%d:%05.2f", minutes, seconds)
        } else {
            return String(format: "%.2f", seconds)
        }
    }

    private func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

// MARK: - 摘要卡片组件
struct SummaryCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    TrendChartView(viewModel: TimerViewModel())
}
