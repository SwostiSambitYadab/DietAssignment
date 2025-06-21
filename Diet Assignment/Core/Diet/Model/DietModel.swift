//
//  DietModel.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

enum Diet {
    enum StreakState: String {
        case completed = "COMPLETED"
        case current = "CURRENT"
        case upcoming = "UPCOMING"
        case unknown
        
        var imageName: String {
            switch self {
            case .completed: return "checkSelected"
            case .current: return "radioSelected"
            case .upcoming: return "radioUnselected"
            case .unknown: return "cancel"
            }
        }
        
        func getImage(_ element: String) -> String? {
            return StreakState(rawValue: element)?.imageName
        }
    }
    
    struct StreakModel {
        let title: String
        let image: String
    }
    
    struct Response: Codable {
        let status, message: String?
        let data: DataClass?
    }

    struct DataClass: Codable {
        let diets: Diets?
    }

    struct Diets: Codable {
        let dietStreak: [String]?
        let allDiets: [AllDiet]?
    }

    struct AllDiet: Codable {
        
        static var mockData: AllDiet {
            let receipes = (0..<3).map { _ in Recipe.mockData }
            return .init(
                daytime: "Morning",
                timings: "06:00 - 12:00",
                progressStatus: .init(total: 3, completed: 1),
                recipes: receipes
            )
        }
        
        let daytime, timings: String?
        let progressStatus: ProgressStatus?
        var recipes: [Recipe]?
    }
    
    
    struct ProgressStatus: Codable {
        let total, completed: Int?
        
        enum CodingKeys: String, CodingKey {
            case completed = "completed"
            case total = "total"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            completed = try values.decodeIfPresent(Int.self, forKey: .completed)
            total = try values.decodeIfPresent(Int.self, forKey: .total)
        }
        
        init(total: Int?, completed: Int?) {
            self.total = total
            self.completed = completed
        }
    }

    struct Recipe: Codable, Identifiable {
        static var mockData: Recipe {
            return .init(
                id: Int(Date.now.timeIntervalSince1970),
                title: "Peach Rice Pudding",
                timeSlot: "06:00",
                duration: 30,
                image: "https://appfeatureimages.s3.amazonaws.com/recipes/Porridge.webp",
                isFavorite: 1,
                isCompleted: 0
            )
        }
        
        var isSelected: Bool? = false
        let id: Int?
        let title, timeSlot: String?
        let duration: Int?
        let image: String?
        var isFavorite, isCompleted: Int?
    }
}
