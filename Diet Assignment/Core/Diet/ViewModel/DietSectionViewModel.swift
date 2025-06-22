//
//  DietSectionViewModel.swift
//  Diet Assignment
//
//  Created by Rahul Kiumar on 22/06/25.
//

import Foundation

class DietSectionViewModel: ObservableObject {
    
    @Published var dietData: Diet.AllDiet
    @Published var isSelected: Bool = false
    @Published var recipes: [Diet.Recipe]
    @Published var progressStatus: Diet.ProgressStatus?
    private let onChangeCompletedStatus: ((String) -> Void)?
    
    init(dietData: Diet.AllDiet, onChangeCompletedStatus: ((String) -> Void)? = nil) {
        self.dietData = dietData
        self.recipes = dietData.recipes ?? []
        self.progressStatus = dietData.progressStatus
        self.onChangeCompletedStatus = onChangeCompletedStatus
    }
}

// MARK: - Business Logic & Helper Methods
extension DietSectionViewModel {
    
    /// - Checking if all the receipes are completed or not
    var canShowFooter: Bool {
        return !recipes.allSatisfy({ $0.isCompleted?.toBool() == true })
    }
    
    /// - For updating the receipes with callback
    func updateReceipes(id: Int) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isSelected = false
        }
        
        /// resetting the `isSelected` variable if all the recipes are deselected
        let allUnselected = recipes.allSatisfy { $0.isSelected == false }
        if allUnselected {
            isSelected = false
        }
    }
    
    func updateReceipeFavorites(id: Int) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isFavorite = recipes[index].isFavorite == 0 ? 1 : 0
        }
    }
    
    /// - For handling the `isSelcted` Variable status change
    func handleOnSelectedStatus() {
        // updating the recipes to reload the view
        recipes = recipes.map {
            var updated = $0
            updated.isSelected = !isSelected
            return updated
        }
        isSelected.toggle()
    }
    
    /// - Update the completed status of recipe
    func updateRecipeCompletedStatus(id: Int) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isCompleted = recipes[index].isCompleted == 0 ? 1 : 0
        }
        progressStatus?.completed = (progressStatus?.completed ?? 0) + 1
        if progressStatus?.completed == progressStatus?.total {
            updateOnCompletedCallback()
        }
    }
    
    private func updateOnCompletedCallback() {
        onChangeCompletedStatus?(dietData.daytime ?? "")
    }
    
    /// - updating `isCompleted` status and progress count
    func onTapFed() {
        recipes = recipes.map {
            var updated = $0
            updated.isCompleted = 1
            updated.isSelected = false
            return updated
        }
        progressStatus?.completed = progressStatus?.total ?? 1
        updateOnCompletedCallback()
    }
    
    /// - For getting 12 hours format for timings
    func getTimingPeriod() -> String {
        guard let timings = dietData.timings?.split(separator: "-") else { return "" }
        let startTime = timings.first?.trimmingCharacters(in: .whitespaces).to12HourFormat() ?? ""
        let endTime = timings.last?.trimmingCharacters(in: .whitespaces).to12HourFormat() ?? ""
        return "\(startTime) - \(endTime)"
    }
}
