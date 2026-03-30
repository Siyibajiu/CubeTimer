import SwiftUI
import Combine

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showSaveAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // 顶部：打乱步骤（可点击刷新，约占25%）
            VStack {
                Button(action: {
                    viewModel.newScramble()
                }) {
                    HStack(spacing: 8) {
                        Text(viewModel.currentScramble)
                            .font(.system(.title, design: .monospaced))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)

                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.25)

            // 中间：记录按钮和时间（约占25%）
            VStack(spacing: 20) {
                // 记录按钮
                Button(action: {
                    if viewModel.currentTime > 0 {
                        showSaveAlert = true
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("记录成绩")
                    }
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(viewModel.currentTime > 0 ? Color.green : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                }
                .disabled(viewModel.currentTime == 0)

                // 时间显示
                Text(viewModel.formattedTime(viewModel.currentTime))
                    .font(.system(size: 56, weight: .thin, design: .monospaced))

                Spacer()
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.25)

            // 底部：开始/停止按钮（约占50%）
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
            .frame(maxHeight: .infinity)
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
