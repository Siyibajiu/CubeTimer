import Foundation
import SwiftUI
import Combine

class PracticeViewModel: ObservableObject {
    @Published var currentFormula: Formula?
    @Published var practiceData: [UUID: FormulaPractice] = [:]
    private var formulas: [Formula] = []
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
            incrementPracticeCount(current.id)
        }

        // 移动到下一个
        currentIndex = (currentIndex + 1) % formulas.count
        currentFormula = formulas[currentIndex]
    }

    func toggleMastered(_ formula: Formula) {
        if var data = practiceData[formula.id] {
            data.isMastered.toggle()
            practiceData[formula.id] = data
        } else {
            practiceData[formula.id] = FormulaPractice(formulaId: formula.id, isMastered: true, practiceCount: 0, lastPracticed: nil)
        }
        savePracticeProgress()
    }

    func getPracticeCount(for formula: Formula) -> Int {
        return practiceData[formula.id]?.practiceCount ?? 0
    }

    func isMastered(_ formula: Formula) -> Bool {
        return practiceData[formula.id]?.isMastered ?? false
    }

    private func incrementPracticeCount(_ formulaId: UUID) {
        if var data = practiceData[formulaId] {
            data.practiceCount += 1
            data.lastPracticed = Date()
            practiceData[formulaId] = data
        } else {
            practiceData[formulaId] = FormulaPractice(formulaId: formulaId, isMastered: false, practiceCount: 1, lastPracticed: Date())
        }
        savePracticeProgress()
    }

    private func savePracticeProgress() {
        let progressList = Array(practiceData.values)
        if let data = try? JSONEncoder().encode(progressList) {
            UserDefaults.standard.set(data, forKey: "formulaPracticeProgress")
        }
    }

    private func loadPracticeProgress() {
        if let data = UserDefaults.standard.data(forKey: "formulaPracticeProgress"),
           let decoded = try? JSONDecoder().decode([FormulaPractice].self, from: data) {
            practiceData = Dictionary(uniqueKeysWithValues: decoded.map { ($0.formulaId, $0) })
        }
    }
}
