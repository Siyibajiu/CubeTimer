import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var viewMode: StatsViewMode = .list
    @State private var sortBy: SortOption = .date
    @State private var sortOrder: SortOrder = .descending
    @State private var selectedDate: Date?
    @State private var showDayDetail = false

    var sortedSolves: [Solve] {
        let sorted = viewModel.solves.sorted { solve1, solve2 in
            switch sortBy {
            case .date:
                return sortOrder == .ascending ? solve1.date < solve2.date : solve1.date > solve2.date
            case .time:
                return sortOrder == .ascending ? solve1.time < solve2.time : solve1.time > solve2.time
            }
        }
        return sorted
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 统计数据卡片
                VStack(spacing: 12) {
                    HStack {
                        Text("成绩统计")
                            .font(.title2)
                            .bold()

                        Spacer()

                        Text("共 \(viewModel.solves.count) 条记录")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()

                    HStack(spacing: 12) {
                        StatCard(
                            title: "PB",
                            value: viewModel.pb.map { viewModel.formattedTime($0) } ?? "--:--.---",
                            color: .yellow
                        )

                        StatCard(
                            title: "Ao5",
                            value: viewModel.ao5.map { viewModel.formattedTime($0) } ?? "需5次",
                            color: .blue
                        )

                        StatCard(
                            title: "Ao12",
                            value: viewModel.ao12.map { viewModel.formattedTime($0) } ?? "需12次",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.05))

                // 视图模式切换
                Picker("View Mode", selection: $viewMode) {
                    ForEach(StatsViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom)

                // 根据选择的模式显示不同内容
                switch viewMode {
                case .list:
                    listView
                case .heatmap:
                    heatmapView
                case .trend:
                    trendView
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showDayDetail) {
            if let selectedDate = selectedDate {
                DayDetailView(date: selectedDate, viewModel: viewModel)
            }
        }
    }

    // MARK: - 列表视图
    private var listView: some View {
        VStack(spacing: 0) {
            // 排序控制
            HStack(spacing: 12) {
                Picker("排序方式", selection: $sortBy) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                Button(action: {
                    sortOrder.toggle()
                }) {
                    Image(systemName: sortOrder == .ascending ? "arrow.up" : "arrow.down")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))

            // 成绩列表内容
            if viewModel.solves.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("还没有记录")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 50)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(sortedSolves) { solve in
                        SolveCard(solve: solve, viewModel: viewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.deleteSolve(solve)
                                    }
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding()
                .padding(.bottom)
            }
        }
    }

    // MARK: - 热力图视图
    private var heatmapView: some View {
        ActivityHeatMap(
            viewModel: viewModel,
            selectedDate: $selectedDate,
            showDayDetail: $showDayDetail
        )
        .padding(.horizontal)
        .padding(.bottom)
    }

    // MARK: - 趋势图表视图
    private var trendView: some View {
        TrendChartView(viewModel: viewModel)
            .padding(.horizontal)
            .padding(.bottom)
    }
}

// 排序选项
// 统计视图模式
enum StatsViewMode: String, CaseIterable {
    case list = "列表"
    case heatmap = "活跃度"
    case trend = "趋势"
}

enum SortOption: CaseIterable {
    case date
    case time

    var displayName: String {
        switch self {
        case .date: return "日期"
        case .time: return "用时"
        }
    }
}

// 统计卡片组件
struct StatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(height: 20)

            Text(value)
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }
}

// 排序顺序
enum SortOrder {
    case ascending
    case descending

    mutating func toggle() {
        self = self == .ascending ? .descending : .ascending
    }
}

// 成绩卡片
struct SolveCard: View {
    let solve: Solve
    let viewModel: TimerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 顶部：排名和日期
            HStack {
                Text("#\(viewModel.getRank(for: solve))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30)

                Text(formatDate(solve.date))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(solve.time, format: .number.precision(.fractionLength(2)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // 中间：用时
            Text(formatTime(solve.time))
                .font(.system(size: 36, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)

            // 底部：打乱步骤
            Text(solve.scramble)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%02d:%05.2f", minutes, seconds)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - 练习活跃度热力图
struct ActivityHeatMap: View {
    @ObservedObject var viewModel: TimerViewModel
    @Binding var selectedDate: Date?
    @Binding var showDayDetail: Bool

    private let calendar = Calendar.current

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("今年练习活跃度")
                    .font(.headline)
                Spacer()
                Text("← 滑动查看更多")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            // 热力图
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 2) {
                    // 星期标签
                    HStack(spacing: 2) {
                        ForEach(["一", "", "三", "", "五", "", "日"], id: \.self) { day in
                            if !day.isEmpty {
                                Text(day)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 11, height: 11)
                            } else {
                                Color.clear
                                    .frame(width: 11, height: 11)
                            }
                        }
                    }

                    // 每周的格子（52-53周）
                    let weeks = generateYearData()
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(11), spacing: 2), count: 53), spacing: 2) {
                        ForEach(weeks, id: \.id) { dayData in
                            DayCell(dayData: dayData)
                                .onTapGesture {
                                    if dayData.count > 0 {
                                        selectedDate = dayData.date
                                        showDayDetail = true
                                    }
                                }
                        }
                    }
                    .frame(width: CGFloat(53 * 13))
                }
            }

            // 图例
            HStack(spacing: 4) {
                Text("少")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                ForEach(0..<5) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(colorForLevel(level))
                        .frame(width: 11, height: 11)
                }
                Text("多")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("共 \(viewModel.solves.count) 次练习")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
    }

    // 生成一年的数据（365天，按周排列）
    private func generateYearData() -> [DayData] {
        let today = Date()
        let daySolves = viewModel.getSolvesByDay()

        // 获取今年的1月1日
        let year = calendar.component(.year, from: today)
        var startDate = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) ?? today

        // 找到1月1日是周几，往前推到周一
        let weekday = calendar.component(.weekday, from: startDate)
        let daysFromMonday = (weekday == 1 ? 6 : weekday - 2)
        startDate = calendar.date(byAdding: .day, value: -daysFromMonday, to: startDate) ?? startDate

        // 创建日期格式化器
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current

        // 生成一年的数据（大约53周）
        var allDays: [DayData] = []
        var currentDate = startDate

        // 计算今年有多少天（考虑闰年）
        let daysInYear = calendar.range(of: .day, in: .year, for: today)?.count ?? 365
        let totalWeeks = ((daysInYear + daysFromMonday) + 6) / 7 // 向上取整

        for _ in 0..<(totalWeeks * 7) {
            let dayString = formatter.string(from: currentDate)
            let count = daySolves[dayString]?.count ?? 0
            allDays.append(DayData(id: UUID(), date: currentDate, count: count))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return allDays
    }

    private func colorForLevel(_ level: Int) -> Color {
        switch level {
        case 0: return Color.gray.opacity(0.2)
        case 1: return Color.green.opacity(0.4)
        case 2: return Color.green.opacity(0.6)
        case 3: return Color.green.opacity(0.8)
        case 4: return Color.green
        default: return Color.green
        }
    }

    // 将行优先的数据重新组织为列优先（适用于LazyVGrid）
    private func reorganizeForColumns(_ data: [DayData], columns: Int) -> [DayData] {
        guard !data.isEmpty else { return [] }

        var result: [DayData] = []
        let rows = (data.count + columns - 1) / columns

        for col in 0..<columns {
            for row in 0..<rows {
                let index = row * columns + col
                if index < data.count {
                    result.append(data[index])
                }
            }
        }

        return result
    }
}

// 单日数据
struct DayData: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let count: Int
}

// 单日格子
struct DayCell: View {
    let dayData: DayData

    var body: some View {
        let level = min(dayData.count, 4)
        let color: Color = {
            if level == 0 {
                return Color.gray.opacity(0.2)
            } else {
                return Color.green.opacity(0.25 + Double(level) * 0.1875)
            }
        }()

        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 11, height: 11)
    }
}

// MARK: - 单日详情视图
struct DayDetailView: View {
    let date: Date
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss

    private var daySolves: [Solve] {
        viewModel.getSolvesForDate(date)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 日期标题
                HStack {
                    Text(formatDate(date))
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text("共 \(daySolves.count) 次练习")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.05))

                if daySolves.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("当天没有练习记录")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(daySolves) { solve in
                                SolveCard(solve: solve, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("练习详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

#Preview {
    StatsView(viewModel: TimerViewModel())
}
