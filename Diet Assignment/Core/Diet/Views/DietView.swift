//
//  DietPlan.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

struct DietView: View {
    
    @StateObject private var vm: DietViewModel = .init(service: DietAPIService())
    
    var body: some View {
        VStack(spacing: 16) {
            navigationBar
                .padding(.horizontal)
            ScrollView {
                VStack(spacing: 16) {
                    headerLayer
                        .padding(.horizontal)
                    dietStreakLayer
                        .padding(.horizontal)
                    searchFilterLayer
                        .padding(.horizontal)
                    dietListingLayer
                }
            }
            .scrollIndicators(.hidden)
        }
        .alert("Error", isPresented: Binding(value: $vm.errorMessage)) {
            Button("Try Again!", role: .cancel) {
                vm.errorMessage = nil
                vm.fetchAllDiets()
            }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
}

#Preview {
    DietView()
}

extension DietView {
    private var navigationBar: some View {
        Image(.backArrow)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                debugPrint("Pop back to previous screen")
            }
    }
    
    private var headerLayer: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Everyday Diet Plan")
                    .font(.dmSansFont(weight: .Bold, size: 20))
                    .foregroundStyle(.appBlack)
                Text("Track Ananya’s every meal")
                    .font(.dmSansFont(weight: .Medium, size: 14))
                    .foregroundStyle(.appGrayText)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Image(.cart)
                    .onTapGesture {
                        debugPrint("Navigate to Cart")
                    }
                Text("Grocery List")
                    .font(.dmSansFont(weight: .Medium, size: 12))
                    .foregroundStyle(.appBlack)
            }
        }
    }
    
    private var dietStreakLayer: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Diet Streak")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.dmSansFont(weight: .Bold, size: 18))
                    .foregroundStyle(.appBlack)
                HStack(spacing: 8) {
                    Image(.streakFire)
                    
                    Text("^[1 streak](inflect: true)")
                        .font(.dmSansFont(weight: .Medium, size: 14))
                        .foregroundStyle(.appGrayText)
                        .offset(y: 1)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background {
                    Capsule()
                        .fill(.white)
                        .stroke(.appBlue, lineWidth: 1)
                }
            }
            
            HStack {
                ForEach(vm.getStreakModel(), id: \.title) { streak in
                    VStack(spacing: 4) {
                        Text(streak.title)
                            .font(.dmSansFont(weight: .Medium, size: 12))
                            .foregroundStyle(.appBlack)
                        
                        Image(streak.image)
                            .foregroundStyle(.appGreen)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.appLightGreen)
                .stroke(.appGreenBorder, lineWidth: 2)
        )
    }
    
    private var searchFilterLayer: some View {
        HStack(spacing: 24) {
            HStack(spacing: 10) {
                Image(.search)
                
                TextField(
                    "Search Meals",
                    text: $vm.searchText,
                    prompt: Text("Search Meals").foregroundStyle(.appPlaceholder)
                )
                .font(.dmSansFont(weight: .Medium, size: 14))
                .foregroundStyle(.appBlack)
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .stroke(.appPlaceholder, lineWidth: 1)
            )
            
            Image(.filter)
        }
    }
    private var dietListingLayer: some View {
        LazyVStack(spacing: 8) {
            ForEach(vm.diets?.allDiets ?? [], id: \.daytime) { allDiet in
                DietSection(dietData: allDiet)
                    .padding(.horizontal)
                    .background(.white, in: .rect(cornerRadius: 8))
            }
        }
        .background(Color(uiColor: .systemGray6))
    }
}
