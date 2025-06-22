//
//  DietViewModel.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

@MainActor
class DietViewModel: ObservableObject {
    
    // MARK: - Properties
    private var tasks: [Task<Void, Never>] = []
    private let service: DietService
    
    @Published var diets: Diet.Diets? = nil
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var streaks: [Diet.StreakModel] = []
    @Published var streakCount: Int = 0
    
    // MARK: - Life Cycle
    init(service: DietService) {
        self.service = service
        fetchAllDiets()
    }
    
    deinit {
        tasks.forEach { $0.cancel() }
    }
    
    // MARK: - Helper methods
    /// - Updating the streaks
    private func updateStreakModel() {
        guard let streaks = diets?.dietStreak else { return }
        self.streaks = streaks.enumerated().map { offset, element in
            Diet.StreakModel(title: getTitle(for: offset), image: Diet.StreakState(rawValue: element)?.imageName ?? "")
        }
        streakCount = streaks.count(where: { $0 == "COMPLETED" })
    }
    
    /// - For getting the title of the streak
    private func getTitle(for offset: Int) -> String {
        switch offset {
        case 0: return "Morning"
        case 1: return "Afternoon"
        case 2: return "Evening"
        default: return "Night"
        }
    }
    
    func updateStreakStatus(_ dayTime: String) {
        if let index = streaks.firstIndex(where: { dayTime.hasPrefix($0.title) }) {
            diets?.dietStreak?[index] = "COMPLETED"
            updateStreakModel()
        }
    }
}

// MARK: - Service calls
extension DietViewModel {
    func fetchAllDiets() {
        let task = Task {
            HUDPresenter.shared.show()
            let (response, success, message) = await service.fetchAllDiets()
            HUDPresenter.shared.hide()
            if success {
                diets = response
                updateStreakModel()
            } else {
                errorMessage = message
                debugPrint("Failed with error: \(message)")
            }
        }
        tasks.append(task)
    }
}
