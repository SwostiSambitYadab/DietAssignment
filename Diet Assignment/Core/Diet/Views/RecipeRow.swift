//
//  RecipeRow.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI
import Kingfisher

struct RecipeRow: View {
    
    let recipe: Diet.Recipe?
    var onSelectedTap: (() -> Void)? = nil
    var onTapFavorite: (() -> Void)? = nil
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 4) {
            if recipe?.isSelected == true {
                Image(.checkboxSelected)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe?.timeSlot?.to12HourFormat() ?? "")
                    .font(.dmSansFont(weight: .Bold, size: 16))
                    .foregroundStyle(.appGrayText)
                    .padding(.horizontal, 8)
                
                HStack {
                    KFImage(URL(string: recipe?.image ?? ""))
                        .placeholder { _ in
                            ProgressView()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110)
                        .clipShape(.rect(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Text(recipe?.title ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2...2)
                            
                            Button {
                                onTapFavorite?()
                            } label: {
                                Image(systemName: recipe?.isFavorite?.toBool() == true ? "heart.fill" : "heart")
                                    .foregroundStyle(recipe?.isFavorite?.toBool() == true ? .appBlue : .appGrayText)
                            }
                            .buttonStyle(.scaleButtonStyle)
                        }
                        
                        HStack {
                            Image(.clock)
                            Text("\(recipe?.duration ?? 0) mins")
                                .font(.dmSansFont(weight: .Regular, size: 10))
                                .foregroundStyle(.appBlack)
                        }
                        .padding(.horizontal, 4)
                        .background(.white)
                        
                        Rectangle()
                            .fill(.appPlaceholder)
                            .frame(height: 1)
                        
                        HStack(spacing: 8) {
                            AppButton(
                                icon: .customize,
                                title: "Customize",
                                hasBorder: false,
                                color: .appBlue,
                                font: .dmSansFont(weight: .Bold, size: 12),
                                fontColor: .white,
                                onTap: {
                                    debugPrint("Customize Tapped")
                                }
                            )
                            
                            if recipe?.isSelected ?? false == false {
                                AppButton(
                                    icon: recipe?.isCompleted?.toBool() == true ? .checkSelected : .checkCircle,
                                    title: recipe?.isCompleted?.toBool() == true ?  "Fed" : "Fed?",
                                    hasBorder: true,
                                    color:  recipe?.isCompleted?.toBool() == true ? .appGrayText : .appBlue,
                                    font: .dmSansFont(weight: recipe?.isCompleted?.toBool() == true ? .Regular : .Bold, size: 12),
                                    fontColor: recipe?.isCompleted?.toBool() == true ? .appGrayText : .appBlue,
                                    onTap: {
                                        debugPrint("Fed Tapped")
                                    }
                                )
                                .foregroundStyle(.appBlue)
                            } else {
                                VStack {}
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(8)
                .background(.appLightBlue, in: .rect(cornerRadius: 12))
            }
        }
        .onTapGesture {
            if recipe?.isSelected == true {
                onSelectedTap?()
            }
        }
    }
}

#Preview {
    RecipeRow(recipe: Diet.Recipe.mockData)
}
