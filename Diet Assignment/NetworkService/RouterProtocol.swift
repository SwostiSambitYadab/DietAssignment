//
//  RouterProtocol.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import Foundation

public typealias RequestParameters = [String: Any]
public typealias RequestHeaders = [String: String]

public protocol RouterProtocol {
        
    var method: HTTPMethod { get }
    var baseUrlString: String { get }
    
    var path: String { get }
    var parameters: RequestParameters? { get }
    var headers: RequestHeaders? { get }
    var arrayParameters: [Any]? { get }
    var requestType: RequestType { get }
    
    var files: [MultiPartData]? { get }
    var deviceInfo: RequestParameters? { get }
}


public enum RequestType {
    case data
    case download
    case upload
}

public extension RouterProtocol {
    
    var baseUrlString: String {
        return "https://uptodd.com/"
    }
    
    var arrayParameters: [Any]? {
        return nil
    }
    
    func asNormalURLRequest() -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: baseUrlString) else {
            return nil
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url?.appending(path: path) else {
            return nil
        }
        
        debugPrint("Whole url :: \(url)")
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 30
        )
        
        request.allHTTPHeaderFields = headers
        
        if requestType == .upload {
            let boundary = NetworkService.boundaryConstant
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpMethod = method.rawValue
        request.httpBody = requestType != .upload ? jsonBody : formDataBody
        return request
    }
}

extension RouterProtocol {
    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else {
            return nil
        }
        
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            if let value {
                return URLQueryItem(name: key, value: "\(value)")
            } else {
                return URLQueryItem(name: key, value: nil)
            }
        }
    }
        
    private var formDataBody: Data? {
        
        guard [.post].contains(method), let parameters = parameters else {
            return nil
        }
        
        let httpBody = NSMutableData()
        let boundary = NetworkService.boundaryConstant

        if let files, files.count > 0 {
            
            for file in files {
                httpBody.append(dataFormField(named: file.fileName, data: file.data, mimeType: file.mimeType, boundary: boundary))
            }
            
        } else {
            for (key, value) in parameters {
                if let stringValue = value as? String ?? "\(value)" as String? {
                    print("Appending field: \(key) = \(value)")
                    httpBody.append(textFormField(named: key, value: stringValue, boundary: boundary))
                }
            }
        }
        
        httpBody.append("--\(boundary)--\r\n")
        
        if let bodyString = String(data: httpBody as Data, encoding: .utf8) {
            print("Final Form Data Request Body:\n\(bodyString)")
        }
        return httpBody as Data
    }
    
    private var jsonBody: Data? {
        guard [.post, .put, .patch].contains(method), let parameters else {
            return nil
        }
        
        var jsonBody: Data?
        
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
}


extension RouterProtocol {
    private func textFormField(named name: String, value: Any, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    private func dataFormField(named name: String,
                               data: Data,
                               mimeType: String, boundary: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
