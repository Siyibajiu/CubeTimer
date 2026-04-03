import SwiftUI
import UniformTypeIdentifiers

struct StatsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var viewMode: StatsViewMode = .list
    @State private var sortBy: SortOption = .date
    @State private var sortOrder: SortOrder = .descending
    @State private var selectedDate: Date?
    @State private var showDayDetail = false
    @State private var filterCategory: CFOPStage? = nil  // 分类筛选

    // 导出/导入相关状态
    @State private var showExportSheet = false
    @State private var showImportPicker = false
    @State private var exportFileURL: URL?
    @State private var showImportAlert = false
    @State private var importMessage = ""

    var filteredSolves: [Solve] {
        let base = viewModel.solves
        if let category = filterCategory {
            return base.filter { $0.category == category }
        }
        return base
    }

    var sortedSolves: [Solve] {
        let sorted = filteredSolves.sorted { solve1, solve2 in
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

                        Text("共 \(filteredSolves.count) 条记录")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        // 导出按钮
                        Button(action: {
                            if let url = viewModel.exportData() {
                                exportFileURL = url
                                showExportSheet = true
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                        }
                        .disabled(viewModel.solves.isEmpty)

                        // 导入按钮
                        Button(action: {
                            showImportPicker = true
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()

                    // 分类筛选器
                    Picker("筛选分类", selection: $filterCategory) {
                        Text("全部").tag(nil as CFOPStage?)
                        Text("F2L").tag(CFOPStage.f2l as CFOPStage?)
                        Text("OLL").tag(CFOPStage.oll as CFOPStage?)
                        Text("PLL").tag(CFOPStage.pll as CFOPStage?)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    HStack(spacing: 12) {
                        StatCard(
                            title: "PB",
                            value: viewModel.pb(for: filterCategory).map { viewModel.formattedTime($0) } ?? "--:--.---",
                            color: .yellow
                        )

                        StatCard(
                            title: "Ao5",
                            value: viewModel.ao5(for: filterCategory).map { viewModel.formattedTime($0) } ?? "需5次",
                            color: .blue
                        )

                        StatCard(
                            title: "Ao12",
                            value: "需12次",  // 简化显示，专项计时通常不需要Ao12
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
        .sheet(isPresented: $showExportSheet) {
            if let fileURL = exportFileURL {
                ActivityViewController(activityItems: [fileURL])
            }
        }
        .fileImporter(
            isPresented: $showImportPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    if viewModel.importData(from: url) {
                        importMessage = "导入成功！"
                    } else {
                        importMessage = "导入失败，请检查文件格式。"
                    }
                    showImportAlert = true
                }
            case .failure(let error):
                importMessage = "导入失败: \(error.localizedDescription)"
                showImportAlert = true
            }
        }
        .alert("导入结果", isPresented: $showImportAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(importMessage)
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

    // 静态 DateFormatter，避免重复创建
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 顶部：排名、日期和分类标签
            HStack {
                Text("#\(viewModel.getRank(for: solve))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30)

                Text(formatDate(solve.date))
                    .font(.caption)
                    .foregroundColor(.secondary)

                // 分类标签
                if let category = solve.category {
                    Text(category.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(categoryColor(for: category).opacity(0.2))
                        .foregroundColor(categoryColor(for: category))
                        .cornerRadius(4)
                }

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
        return Self.dateFormatter.string(from: date)
    }

    private func categoryColor(for category: CFOPStage) -> Color {
        switch category {
        case .f2l:
            return .blue
        case .oll:
            return .orange
        case .pll:
            return .purple
        }
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
                Text("共 \(viewModel.solves.count) 次练习")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            // 热力图 - 多列布局，一屏显示
            let months = monthlyData()
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                spacing: 8
            ) {
                ForEach(months, id: \.month) { monthData in
                    CompactMonthHeatMap(
                        monthData: monthData,
                        selectedDate: $selectedDate,
                        showDayDetail: $showDayDetail
                    )
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
                        .frame(width: 12, height: 12)
                }
                Text("多")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
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

    // 按月分组数据
    private func monthlyData() -> [(month: Int, name: String, weeks: [[DayData]])] {
        let allDays = generateYearData()

        var months: [(month: Int, name: String, weeks: [[DayData]])] = []
        let monthNames = ["1月", "2月", "3月", "4月", "5月", "6月",
                         "7月", "8月", "9月", "10月", "11月", "12月"]

        // 按月分组
        for month in 1...12 {
            let monthDays = allDays.filter { day in
                let components = calendar.dateComponents([.month], from: day.date)
                return components.month == month
            }

            if !monthDays.isEmpty {
                // 按周分组（每周7天）
                var weeks: [[DayData]] = []
                var currentWeek: [DayData] = []

                for day in monthDays {
                    currentWeek.append(day)
                    if currentWeek.count == 7 {
                        weeks.append(currentWeek)
                        currentWeek = []
                    }
                }

                // 添加最后一周（可能不满7天）
                if !currentWeek.isEmpty {
                    weeks.append(currentWeek)
                }

                months.append((month: month, name: monthNames[month-1], weeks: weeks))
            }
        }

        return months
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

        // 生成一年的数据（大约53周）
        var allDays: [DayData] = []
        var currentDate = startDate

        // 计算今年有多少天（考虑闰年）
        let daysInYear = calendar.range(of: .day, in: .year, for: today)?.count ?? 365
        let totalWeeks = ((daysInYear + daysFromMonday) + 6) / 7 // 向上取整

        for _ in 0..<(totalWeeks * 7) {
            let dayString = dayFormatter.string(from: currentDate)
            let count = daySolves[dayString]?.count ?? 0
            allDays.append(DayData(date: currentDate, count: count))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return allDays
    }

    // 复用DateFormatter，避免重复创建
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

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
}

// 单日数据
struct DayData: Identifiable, Hashable {
    let id: Int  // 使用date的哈希值作为ID，避免创建大量UUID对象
    let date: Date
    let count: Int

    init(date: Date, count: Int) {
        self.date = date
        self.count = count
        self.id = abs(date.hashValue)
    }
}

// 单日格子
struct DayCell: View {
    let dayData: DayData
    var size: CGFloat = 11

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
            .frame(width: size, height: size)
    }
}

// 月份热力图
struct MonthHeatMap: View {
    let monthData: (month: Int, name: String, weeks: [[DayData]])
    @Binding var selectedDate: Date?
    @Binding var showDayDetail: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 月份标题
            Text(monthData.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            // 该月的周热力图
            VStack(alignment: .leading, spacing: 2) {
                ForEach(monthData.weeks.indices, id: \.self) { weekIndex in
                    HStack(spacing: 2) {
                        ForEach(monthData.weeks[weekIndex], id: \.id) { dayData in
                            DayCell(dayData: dayData, size: 14)
                                .onTapGesture {
                                    if dayData.count > 0 {
                                        selectedDate = dayData.date
                                        showDayDetail = true
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.05))
        )
    }
}

// 紧凑月份热力图 - 用于3列布局
struct CompactMonthHeatMap: View {
    let monthData: (month: Int, name: String, weeks: [[DayData]])
    @Binding var selectedDate: Date?
    @Binding var showDayDetail: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 月份标题
            Text(monthData.name)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            // 该月的周热力图 - 紧凑布局
            VStack(alignment: .leading, spacing: 1) {
                ForEach(monthData.weeks.indices, id: \.self) { weekIndex in
                    HStack(spacing: 1) {
                        ForEach(monthData.weeks[weekIndex], id: \.id) { dayData in
                            DayCell(dayData: dayData, size: 10)
                                .onTapGesture {
                                    if dayData.count > 0 {
                                        selectedDate = dayData.date
                                        showDayDetail = true
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }
}

// MARK: - 单日详情视图
struct DayDetailView: View {
    let date: Date
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) var dismiss

    // 静态 DateFormatter，避免重复创建
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()

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
        return Self.dateFormatter.string(from: date)
    }
}

// MARK: - 分享视图控制器
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

#Preview {
    StatsView(viewModel: TimerViewModel())
}
