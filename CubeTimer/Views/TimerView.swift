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

            // 中间：按钮组和时间/观察倒计时（约占25%）
            VStack(spacing: 20) {
                // 按钮组
                HStack(spacing: 15) {
                    // 观察/取消按钮（固定宽度）
                    if viewModel.isInspecting {
                        // 取消观察按钮
                        Button(action: {
                            viewModel.cancelInspection()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark.circle.fill")
                                Text("取消")
                            }
                            .font(.title3)
                            .frame(maxWidth: .infinity)  // 占满可用空间
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.3))
                            .foregroundColor(.red)
                            .cornerRadius(20)
                        }
                    } else {
                        // 观察按钮
                        Button(action: {
                            viewModel.startInspection()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "eye.fill")
                                Text("观察")
                            }
                            .font(.title3)
                            .frame(maxWidth: .infinity)  // 占满可用空间
                            .padding(.vertical, 10)
                            .background(Color.orange.opacity(0.3))
                            .foregroundColor(.orange)
                            .cornerRadius(20)
                        }
                        .disabled(viewModel.isRunning)
                    }

                    // 记录按钮（固定宽度）
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
                        .frame(maxWidth: .infinity)  // 占满可用空间
                        .padding(.vertical, 10)
                        .background(viewModel.currentTime > 0 ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .disabled(viewModel.currentTime == 0 || viewModel.isInspecting)
                }
                .padding(.horizontal, 40)  // 限制整体宽度

                // 观察倒计时或时间显示（固定高度防止跳动）
                VStack(spacing: 8) {
                    if viewModel.isInspecting {
                        // 观察倒计时
                        Text("\(viewModel.inspectionTime)")
                            .font(.system(size: 100, weight: .bold, design: .rounded))
                            .foregroundColor(inspectionColor(viewModel.inspectionTime))

                        if viewModel.inspectionTime <= 8 {
                            Text("WARNING")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.orange)
                        }
                    } else {
                        // 正常时间显示
                        Text(viewModel.formattedTime(viewModel.currentTime))
                            .font(.system(size: 56, weight: .thin, design: .monospaced))

                        if viewModel.isReadyAfterInspection {
                            Text("就绪")
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                }
                .frame(height: 120)  // 固定高度

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
                    .background(buttonColor)
                    .foregroundColor(.white)
            }
            .frame(maxHeight: .infinity)
            .disabled(viewModel.isInspecting)
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

    // MARK: - 辅助方法
    private func inspectionColor(_ time: Int) -> Color {
        if time <= 3 {
            return .red
        } else if time <= 8 {
            return .orange
        } else {
            return .primary  // 深色，在白色背景上可见
        }
    }

    private var buttonColor: Color {
        if viewModel.isRunning {
            return .red
        } else if viewModel.isReadyAfterInspection {
            return .green
        } else {
            return .green
        }
    }
}

#Preview {
    TimerView(viewModel: TimerViewModel())
}
