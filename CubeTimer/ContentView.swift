import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("计时器")
                }
                .tag(0)

            FormulaListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("公式")
                }
                .tag(1)

            Text("统计功能开发中...")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("统计")
                }
                .tag(2)
        }
    }
}
