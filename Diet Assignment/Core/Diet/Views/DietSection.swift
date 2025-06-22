//
//  DietPlanSection.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

struct DietSection: View {
    
    @StateObject var vm: DietSectionViewModel
    
    var body: some View {
        Section {
            VStack {
                headerLayer
                    .padding(.bottom, 6)
                
                ForEach(vm.recipes) { recipe in
                    RecipeRow(
                        recipe: recipe,
                        onSelectedTap: {
                            vm.updateReceipes(id: recipe.id ?? 0)
                        },
                        onTapFavorite: {
                            vm.updateReceipeFavorites(id: recipe.id ?? 0)
                        },
                        onTapFed: {
                            withAnimation {
                                vm.updateRecipeCompletedStatus(id: recipe.id ?? 0)
                            }
                        }
                    )
                }
            }
            .padding(.vertical)
        }
        footer: {
            if vm.canShowFooter {
                footerLayer
                    .transition(.asymmetric(insertion: .opacity, removal: .scale))
            }
        }
        .animation(.smooth, value: vm.isSelected)
    }
}

#Preview {
    DietSection(vm: .init(dietData: Diet.AllDiet.mockData))
}

extension DietSection {
    private var headerLayer: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.dietData.daytime ?? "")
                        .font(.dmSansFont(weight: .Bold, size: 18))
                        .foregroundStyle(.appBlack)
                    
                    Text(vm.getTimingPeriod())
                        .font(.dmSansFont(weight: .Medium, size: 14))
                        .foregroundStyle(.appGrayText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CircularProgressView(total: vm.progressStatus?.total ?? 1, completed: vm.progressStatus?.completed ?? 1)
            }
            
            if vm.canShowFooter {
                HStack(spacing: 8) {
                    Image(vm.isSelected ? .checkboxSelected : .checkbox)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Select All")
                        .font(.dmSansFont(weight: .Bold, size: 14))
                        .foregroundStyle(.appBlack)
                }
                .onTapGesture {
                    vm.handleOnSelectedStatus()
                }
            }
        }
    }
    
    @ViewBuilder
    private var footerLayer: some View {
        if vm.isSelected {
            HStack {
                AppButton(
                    title: "Fed?",
                    hasBorder: false,
                    color: .appBlue,
                    font: .dmSansFont(weight: .Bold, size: 16),
                    fontColor: .white,
                    height: 40,
                    onTap: {
                        withAnimation {
                            vm.onTapFed()
                        }
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
                        vm.handleOnSelectedStatus()
                    }
                )
            }
            .padding()
        }
    }
}
