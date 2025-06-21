//
//  DietRouter.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

enum DietRouter: RouterProtocol {
    
    case fetchAllDiets
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .fetchAllDiets:
            return "fetch-all-diets"
        }
    }
    
    var parameters: RequestParameters? {
        return nil
    }
    
    var headers: RequestHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    var requestType: RequestType {
        return .data
    }
    
    var files: [MultiPartData]? {
        return nil
    }
    
    var deviceInfo: RequestParameters? {
        return nil
    }
}
