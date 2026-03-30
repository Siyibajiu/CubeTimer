import Foundation

class PracticeViewModel: ObservableObject {
    @Published var currentFormula: Formula?
    @Published var formulas: [Formula] = []
    private var currentIndex = 0

    init() {
        loadFormulas(category: nil)
    }

    func loadFormulas(category: CFOPStage?) {
        let allFormulas = CompleteFormulaData.shared.getAllFormulas()

        if let category = category {
            formulas = allFormulas.filter { $0.category == category }
        } else {
            formulas = allFormulas
        }

        // 加载练习进度
        loadPracticeProgress()

        // 随机打乱顺序
        formulas.shuffle()

        if !formulas.isEmpty {
            currentIndex = 0
            currentFormula = formulas[currentIndex]
        } else {
            currentFormula = nil
        }
    }

    func nextFormula() {
        guard !formulas.isEmpty else { return }

        // 标记当前公式已练习
        if let current = currentFormula {
            incrementPracticeCount(current)
        }

        // 移动到下一个
        currentIndex = (currentIndex + 1) % formulas.count
        currentFormula = formulas[currentIndex]
    }

    func toggleMastered(_ formula: Formula) {
        if let index = formulas.firstIndex(where: { $0.id == formula.id }) {
            formulas[index].isMastered.toggle()
            currentFormula = formulas[index]
            savePracticeProgress()
        }
    }

    private func incrementPracticeCount(_ formula: Formula) {
        if let index = formulas.firstIndex(where: { $0.id == formula.id }) {
            formulas[index].practiceCount += 1
            formulas[index].lastPracticed = Date()
            savePracticeProgress()
        }
    }

    private func savePracticeProgress() {
        let progress = PracticeProgress(formulas: formulas)
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: "formulaPracticeProgress")
        }
    }

    private func loadPracticeProgress() {
        if let data = UserDefaults.standard.data(forKey: "formulaPracticeProgress"),
           let decoded = try? JSONDecoder().decode(PracticeProgress.self, from: data) {
            let progressMap = Dictionary(uniqueKeysWithValues: decoded.formulas.map { ($0.id, $0) })

            for index in formulas.indices {
                if let progress = progressMap[formulas[index].id] {
                    formulas[index].isMastered = progress.isMastered
                    formulas[index].practiceCount = progress.practiceCount
                    formulas[index].lastPracticed = progress.lastPracticed
                }
            }
        }
    }
}

// 练习进度数据结构
struct PracticeProgress: Codable {
    let formulas: [Formula]
}
