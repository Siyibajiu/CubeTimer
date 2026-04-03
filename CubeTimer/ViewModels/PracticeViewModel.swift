import Foundation
import SwiftUI
import Combine
import UIKit

class PracticeViewModel: ObservableObject {
    @Published var currentFormula: Formula?
    @Published var practiceData: [UUID: FormulaPractice] = [:]
    private var formulas: [Formula] = []
    private var currentIndex = 0

    // Debounce 订阅，用于延迟写入
    private var saveCancellable: AnyCancellable?
    private let saveDebounceInterval: TimeInterval = 1.0 // 1秒延迟

    // 缓存所有公式数据，避免重复加载
    private let allFormulasCache: [Formula]

    init() {
        // 只在初始化时加载一次所有公式
        allFormulasCache = CompleteFormulaData.shared.getAllFormulas()

        loadFormulas(category: nil)
        setupDebounceSave()

        // 监听 App 生命周期事件
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveBeforeTerminate),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 设置延迟保存
    private func setupDebounceSave() {
        saveCancellable = $practiceData
            .debounce(for: .seconds(saveDebounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.savePracticeProgress()
            }
    }

    // App 进入后台时立即保存
    @objc private func saveBeforeTerminate() {
        savePracticeProgress()
    }

    func loadFormulas(category: CFOPStage?) {
        // 直接使用缓存的公式数据，避免重复调用 getAllFormulas()
        if let category = category {
            formulas = allFormulasCache.filter { $0.category == category }
        } else {
            formulas = allFormulasCache
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
        // 移除直接保存，由 debounce 自动处理
    }

    func getPracticeCount(for formula: Formula) -> Int {
        return practiceData[formula.id]?.practiceCount ?? 0
    }

    func isMastered(_ formula: Formula) -> Bool {
        return practiceData[formula.id]?.isMastered ?? false
    }

    func toggleError(_ formula: Formula) {
        if var data = practiceData[formula.id] {
            data.hasError.toggle()
            practiceData[formula.id] = data
        } else {
            practiceData[formula.id] = FormulaPractice(formulaId: formula.id, isMastered: false, practiceCount: 0, lastPracticed: nil, hasError: true)
        }
        // 移除直接保存，由 debounce 自动处理
    }

    func hasError(_ formula: Formula) -> Bool {
        return practiceData[formula.id]?.hasError ?? false
    }

    private func incrementPracticeCount(_ formulaId: UUID) {
        if var data = practiceData[formulaId] {
            data.practiceCount += 1
            data.lastPracticed = Date()
            practiceData[formulaId] = data
        } else {
            practiceData[formulaId] = FormulaPractice(formulaId: formulaId, isMastered: false, practiceCount: 1, lastPracticed: Date())
        }
        // 移除直接保存，由 debounce 自动处理
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
