//
//  File.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

protocol DietService {
    func fetchAllDiets() async -> (Diet.Diets?, Bool, String)
}

class DietAPIService: DietService {
    func fetchAllDiets() async -> (Diet.Diets?, Bool, String) {
        let router = DietRouter.fetchAllDiets
        
        do {
            let response: Diet.Response = try await NetworkService.shared.dataRequest(with: router)
            let status = response.status == "success"
            return(status ? response.data?.diets : nil, status, "Something went wrong! Please try again later.")
        } catch {
            debugPrint(error.localizedDescription)
            return(nil, false, "Something went wrong! Please try again later.")
        }
    }
}

class FailableService: DietService {
    func fetchAllDiets() async -> (Diet.Diets?, Bool, String) {
        return (nil, false, "Something went wrong! Please try again later.")
    }
}
