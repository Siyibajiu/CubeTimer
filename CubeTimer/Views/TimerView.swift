import SwiftUI
import Combine

struct TimerView: View {
    @State private var currentTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var scramble = "测试打乱"
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            // 顶部：打乱步骤
            Text(scramble)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)

            Spacer()

            // 中间：重置按钮
            Button(action: {
                resetTimer()
            }) {
                Text("重置")
                    .font(.title3)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.3))
                    .foregroundColor(.blue)
                    .cornerRadius(20)
            }

            // 中间：时间显示
            Text(formattedTime(currentTime))
                .font(.system(size: 72, weight: .thin, design: .monospaced))

            Spacer()

            // 底部：开始按钮（占用一半）
            Button(action: {
                if isRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            }) {
                Text(isRunning ? "停止" : "开始")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
            }
            .frame(height: UIScreen.main.bounds.height / 2)
        }
        .ignoresSafeArea(.keyboard)
    }

    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            currentTime += 0.01
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        currentTime = 0
    }

    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%02d:%05.2f", minutes, seconds)
    }
}

#Preview {
    TimerView()
}
