//
//  DietPlanSection.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

struct DietSection: View {
    @State var dietData: Diet.AllDiet
    @State private var isSelected: Bool = false
    @State private var recipes: [Diet.Recipe]
    
    init(dietData: Diet.AllDiet) {
        self.dietData = dietData
        _recipes = State(initialValue: dietData.recipes ?? [])
    }
    
    var body: some View {
        Section {
            VStack {
                headerLayer
                    .padding(.bottom, 6)
                
                ForEach(recipes) { recipe in
                    RecipeRow(
                        recipe: recipe,
                        onSelectedTap: {
                            updateReceipes(id: recipe.id ?? 0)
                        },
                        onTapFavorite: {
                            updateReceipeFavorites(id: recipe.id ?? 0)
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        footer: {
            if canShowFooter {
                footerLayer
                    .transition(.asymmetric(insertion: .opacity, removal: .scale))
            }
        }
        .animation(.smooth, value: isSelected)
    }
}

#Preview {
    DietSection(dietData: Diet.AllDiet.mockData)
}

extension DietSection {
    
    /// - Checking if all the receipes are completed or not
    private var canShowFooter: Bool {
        return !recipes.allSatisfy({ $0.isCompleted?.toBool() == true })
    }
    
    /// - For updating the receipes with callback
    private func updateReceipes(id: Int) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isSelected = false
        }
        
        /// resetting the `isSelected` variable if all the recipes are deselected
        let allUnselected = recipes.allSatisfy { $0.isSelected == false }
        if allUnselected {
            isSelected = false
        }
    }
    
    private func updateReceipeFavorites(id: Int) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isFavorite = recipes[index].isFavorite == 0 ? 1 : 0
        }
    }
    
    /// - For handling the `isSelcted` Variable status change
    private func handleOnSelectedStatus() {
        // updating the recipes to reload the view
        recipes = recipes.map {
            var updated = $0
            updated.isSelected = !isSelected
            return updated
        }
        isSelected.toggle()
    }
    
    private func getTimingPeriod() -> String {
        guard let timings = dietData.timings?.split(separator: "-") else { return "" }
        let startTime = timings.first?.trimmingCharacters(in: .whitespaces).to12HourFormat() ?? ""
        let endTime = timings.last?.trimmingCharacters(in: .whitespaces).to12HourFormat() ?? ""
        return "\(startTime) - \(endTime)"
    }
}

extension DietSection {
    private var headerLayer: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dietData.daytime ?? "")
                        .font(.dmSansFont(weight: .Bold, size: 18))
                        .foregroundStyle(.appBlack)
                    
                    Text(getTimingPeriod())
                        .font(.dmSansFont(weight: .Medium, size: 14))
                        .foregroundStyle(.appGrayText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CircularProgressView(total: dietData.progressStatus?.total ?? 1, completed: dietData.progressStatus?.completed ?? 1)
            }
            
            if canShowFooter {
                HStack(spacing: 8) {
                    Image(isSelected ? .checkboxSelected : .checkbox)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Select All")
                        .font(.dmSansFont(weight: .Bold, size: 14))
                        .foregroundStyle(.appBlack)
                }
                .onTapGesture {
                    handleOnSelectedStatus()
                }
            }
        }
    }
    
    @ViewBuilder
    private var footerLayer: some View {
        if isSelected {
            HStack {
                AppButton(
                    title: "Fed?",
                    hasBorder: false,
                    color: .appBlue,
                    font: .dmSansFont(weight: .Bold, size: 16),
                    fontColor: .white,
                    height: 40,
                    onTap: {
                        debugPrint("Customize button tapped")
                    }
                )
                
                AppButton(
                    title: "Cancel",
                    hasBorder: true,
                    color: .appBlack,
                    font: .dmSansFont(weight: .Bold, size: 16),
                    fontColor: .appBlack,
                    height: 40,
                    onTap: {
                        handleOnSelectedStatus()
                    }
                )
            }
            .padding()
        }
    }
}
