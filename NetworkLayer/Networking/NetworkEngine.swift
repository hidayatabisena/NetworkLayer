//
//  NetworkEngine.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

protocol NetworkEngineAdapter {
    func invokeEngine<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkEngine: NetworkEngineAdapter {
    func invokeEngine<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = request.url else {
            completion(.failure(.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = request.timeOutInterval
        request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0.rawValue) }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch let decodingError {
                    completion(.failure(.decodingFailed(DecodingError(message: decodingError.localizedDescription))))
                }
                
            case 404:
                completion(.failure(.notFound))
                
            case 408:
                completion(.failure(.timeout))
                
            case 500:
                completion(.failure(.internalServerError))
                
            default:
                completion(.failure(.unknownError(statusCode: httpResponse.statusCode)))
            }
        }.resume()
    }
}
