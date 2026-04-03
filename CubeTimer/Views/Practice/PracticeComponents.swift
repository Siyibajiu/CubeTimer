import SwiftUI

// 答案按钮
struct AnswerButton: View {
    let formula: Formula
    let isSelected: Bool
    let showResult: Bool
    let isCorrect: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formula.name).font(.body).fontWeight(.medium).foregroundColor(.primary)
                    Text(formula.algorithm).font(.system(.caption, design: .monospaced)).foregroundColor(.blue)
                }
                Spacer()
                if showResult, isSelected {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.title2).foregroundColor(isCorrect ? .green : .red)
                }
            }
            .padding().background(backgroundColor).cornerRadius(12)
        }
        .disabled(showResult)
    }

    private var backgroundColor: Color {
        if showResult {
            if isSelected { return isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2) }
            else if isCorrect { return Color.green.opacity(0.1) }
        }
        return isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
    }
}

// 分类按钮
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title).font(.body).fontWeight(.medium)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// 统计项
struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).foregroundColor(.primary)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .padding(.horizontal, 20).padding(.vertical, 12)
        .background(Color.gray.opacity(0.1)).cornerRadius(10)
    }
}

// 移动按钮
struct MoveButton: View {
    let move: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(move).font(.system(.title3, design: .monospaced)).fontWeight(.bold)
                .foregroundColor(.white).frame(height: 50).frame(maxWidth: .infinity)
                .background(Color.blue).cornerRadius(10)
        }
    }
}

// 异步加载本地图片
struct LocalAsyncImage: View {
    let imageName: String
    let content: (LocalAsyncImagePhase) -> AnyView

    init(imageName: String, @ViewBuilder content: @escaping (LocalAsyncImagePhase) -> some View) {
        self.imageName = imageName
        self.content = { phase in AnyView(content(phase)) }
    }

    var body: some View {
        if let image = UIImage(named: imageName) {
            content(.success(Image(uiImage: image)))
        } else {
            content(.empty)
        }
    }

    enum LocalAsyncImagePhase {
        case empty
        case success(Image)
        case failure(Error)
    }
}
