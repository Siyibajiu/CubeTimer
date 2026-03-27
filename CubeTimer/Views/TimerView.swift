import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        VStack(spacing: 40) {
            // 打乱步骤
            Text(viewModel.currentScramble)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()

            // 计时器显示
            Text(viewModel.formattedTime(viewModel.currentTime))
                .font(.system(size: 72, weight: .thin, design: .monospaced))
                .foregroundColor(.primary)

            // 控制按钮
            HStack(spacing: 30) {
                Button(action: {
                    if viewModel.isRunning {
                        viewModel.stop()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Text(viewModel.isRunning ? "停止" : "开始")
                        .font(.title2)
                        .frame(width: 100, height: 50)
                        .background(viewModel.isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    viewModel.reset()
                }) {
                    Text("重置")
                        .font(.title2)
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
