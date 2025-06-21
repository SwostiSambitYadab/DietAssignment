//
//  NetworkService.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation


public protocol NetworkProtocol {
    func dataRequest<Model: Codable>(with request: RouterProtocol) async throws -> Model
}

final class NetworkService: NetworkProtocol {
    private init() {}
    static let shared = NetworkService()
    static let boundaryConstant = "Boundary-\(UUID().uuidString)"
}

extension NetworkService  {
    
    func dataRequest<Model>(with request: any RouterProtocol) async throws -> Model where Model : Decodable, Model : Encodable {
        
        // -- Checking for connection -- //
        guard NetworkMonitor.shared.isReachable else {
            throw NetworkError.requestError(errorMessage: "It seems you're not connected to Internet")
        }
        
        print("ROUTER BASE", request.baseUrlString)
        print("ROUTER PARAMETERS", request.parameters ?? [:])
        print("ROUTER PATH", request.path)
        print("ROUTER VERB", request.method)
        
        // -- Trying to create URLRequest -- //
        guard let request = request.asNormalURLRequest() else {
            throw NetworkError.requestError(errorMessage: "Server is not responding! Please try after sometime.")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // handle status code errors
            if let response = response as? HTTPURLResponse, !response.statusCode.isSuccess {
                debugPrint("FAILED STATUS CODE : \(response.statusCode)")
                try NetworkError.handleStatusCodeError(response.statusCode)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            Debug.printRequest(request, response: response as? HTTPURLResponse, responseString: responseString, error: nil)
            
            let decoder = JSONDecoder()
            let decodedValue = try decoder.decode(Model.self, from: data)
            return decodedValue
            
        } catch {
            let error = error as NSError
            
            if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                throw NetworkError.requestError(errorMessage: "Connection Time Out or Lost.\nPlease try again.")
            }
            throw NetworkError.other(statusCode: nil, error: error)
        }
    }
}
