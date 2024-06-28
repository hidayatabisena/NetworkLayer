//
//  NetworkRequest+Ext.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

extension NetworkRequest {
    var timeoutInterval: TimeInterval { 30 }
    
    func urlRequest() throws -> URLRequest {
        guard let url = url else { throw NetworkError.badURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key.rawValue)
        }
        
        if let parameters = parameters {
            switch method {
            case .get:
                request.url = try appendQueryParameters(to: url, with: parameters)
            default:
                request.httpBody = try encodeParameters(parameters)
            }
        }
        
        return request
    }
    
    private func appendQueryParameters(to url: URL, with parameters: Encodable) throws -> URL {
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let parameterDict = try parameters.asDictionary()
        components?.queryItems = parameterDict.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        return components?.url ?? url
    }
    
    private func encodeParameters(_ parameters: Encodable) throws -> Data {
        do {
            return try JSONEncoder().encode(parameters)
        } catch {
            throw NetworkError.encodingFailed(error)
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NetworkError.encodingFailed(DecodingError(message: "Failed to convert Encodable to dictionary"))
        }
        
        return dictionary
    }
}

