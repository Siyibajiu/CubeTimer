import SwiftUI

// 异步加载图片的组件
struct AsyncFormulaImage: View {
    let url: URL?
    let fallback: Color

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .failure:
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }
        }
    }

    private var fallbackView: some View {
        ZStack {
            fallback
                .opacity(0.3)

            Image(systemName: "cube.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// 预加载的图片缓存
struct ImageCache {
    static let shared = ImageCache()
    private var cache: [String: Image] = [:]

    mutating func get(_ key: String) -> Image? {
        return cache[key]
    }

    mutating func set(_ key: String, image: Image) {
        cache[key] = image
    }
}
