import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var sortBy: SortOption = .date
    @State private var sortOrder: SortOrder = .descending

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
        VStack(spacing: 0) {
            // 顶部：排序控制
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

                // 排序选择
                HStack(spacing: 12) {
                    Picker("排序方式", selection: $sortBy) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    // 升序/降序切换
                    Button(action: {
                        sortOrder.toggle()
                    }) {
                        Image(systemName: sortOrder == .ascending ? "arrow.up" : "arrow.down")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding()

            // 成绩列表
            if viewModel.solves.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("还没有记录")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
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
                }
            }
        }
        .navigationTitle("成绩统计")
    }
}

// 排序选项
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

#Preview {
    StatsView(viewModel: TimerViewModel())
}
