//
//  DietViewModel.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

@MainActor
class DietViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    private var tasks: [Task<Void, Never>] = []
    private let service: DietService
    
    @Published var diets: Diet.Diets? = nil
    @Published var errorMessage: String? = nil
    
    init(service: DietService) {
        self.service = service
        fetchAllDiets()
    }
    
    deinit {
        tasks.forEach { $0.cancel() }
    }
    
    func getStreakModel() -> [Diet.StreakModel] {
        guard let streaks = diets?.dietStreak else { return [] }
        
        return streaks.enumerated().map { offset, element in
            Diet.StreakModel(title: getTitle(for: offset), image: Diet.StreakState(rawValue: element)?.imageName ?? "")
        }
    }
    
    private func getTitle(for offset: Int) -> String {
            switch offset {
            case 0: return "Morning"
            case 1: return "Afternoon"
            case 2: return "Evening"
            default: return "Night"
            }
        }
}
extension DietViewModel {
    func fetchAllDiets() {
        let task = Task {
            HUDPresenter.shared.show()
            let (response, success, message) = await service.fetchAllDiets()
            HUDPresenter.shared.hide()
            if success {
                diets = response
            } else {
                errorMessage = message
                debugPrint("Failed with error: \(message)")
            }
        }
        tasks.append(task)
    }
}
