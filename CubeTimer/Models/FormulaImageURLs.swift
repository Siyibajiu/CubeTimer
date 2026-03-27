import Foundation

class FormulaImageURLs {
    static let shared = FormulaImageURLs()

    private init() {}

    // 为每个公式提供图片URL或本地资源名称
    func getImageURL(for formulaName: String) -> URL? {
        let imageMap: [String: String] = [
            // PLL 图片URL (来自公开资源)
            "PLL T-perm": "https://maru.tw/solutions/圖片/pll/T.png",
            "PLL Y-perm": "https://maru.tw/solutions/圖片/pll/Y.png",
            "PLL Ua-perm": "https://maru.tw/solutions/圖片/pll/Ua.png",
            "PLL Ub-perm": "https://maru.tw/solutions/圖片/pll/Ub.png",

            // 更多公式可以添加对应URL
        ]

        guard let urlString = imageMap[formulaName] else {
            return nil
        }

        return URL(string: urlString)
    }

    // 或者返回本地资源名称
    func getLocalImageName(for formulaName: String) -> String? {
        let imageMap: [String: String] = [
            "PLL T-perm": "pll_t",
            "PLL Y-perm": "pll_y",
            // 可以在Assets.xcassets中添加对应的图片集
        ]

        return imageMap[formulaName]
    }
}
