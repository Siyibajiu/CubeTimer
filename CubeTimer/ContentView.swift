import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("计时器")
                }

            FormulaListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("公式")
                }

            Text("统计功能\n开发中...")
                .font(.title2)
                .multilineTextAlignment(.center)
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
