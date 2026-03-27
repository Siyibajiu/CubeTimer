import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        TabView {
            TimerView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "timer")
                    Text("计时器")
                }

            FormulaListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("公式")
                }

            StatsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("统计")
                }
        }
    }
}

#Preview {
    ContentView()
}
