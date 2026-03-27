import SwiftUI
import Combine

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showSaveAlert = false

    var body: some View {
        VStack(spacing: 20) {
            // 顶部：打乱步骤
            Text(viewModel.currentScramble)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)

            Spacer()

            // 中间：按钮组
            HStack(spacing: 15) {
                // 重置按钮
                Button(action: {
                    viewModel.reset()
                }) {
                    Text("重置")
                        .font(.title3)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.3))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                }

                // 记录按钮
                Button(action: {
                    if viewModel.currentTime > 0 {
                        showSaveAlert = true
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("记录")
                    }
                    .font(.title3)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    .background(viewModel.currentTime > 0 ? Color.green.opacity(0.8) : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }

            // 中间：时间显示
            Text(viewModel.formattedTime(viewModel.currentTime))
                .font(.system(size: 72, weight: .thin, design: .monospaced))

            Spacer()

            // 底部：开始按钮（占用一半）
            Button(action: {
                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            }) {
                Text(viewModel.isRunning ? "停止" : "开始")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(viewModel.isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
            }
            .frame(height: UIScreen.main.bounds.height / 2)
        }
        .ignoresSafeArea(.keyboard)
        .alert("保存成绩", isPresented: $showSaveAlert) {
            Button("保存") {
                viewModel.saveSolve()
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("确定要保存当前成绩吗？")
        }
    }
}

#Preview {
    TimerView(viewModel: TimerViewModel())
}
