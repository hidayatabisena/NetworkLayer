//
//  HTTPResponse.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

public protocol HTTPResponseHandler {
    func handleStatusCode(response: URLResponse?) throws
    func decode<T: Decodable>(data: Data, to type: T.Type) throws -> T
    func extractETag(from response: URLResponse?) -> String?
}

extension HTTPResponseHandler {
    public func decode<T: Decodable>(data: Data, to type: T.Type) throws -> T {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch let decodingError {
            throw NetworkError.decodingFailed(decodingError)
        }
    }

    public func handleStatusCode(response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 404:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.internalServerError
        default:
            throw NetworkError.unknownError(statusCode: httpResponse.statusCode)
        }
    }

    public func extractETag(from response: URLResponse?) -> String? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }
        
        return httpResponse.allHeaderFields["ETag"] as? String
    }
}

public struct DefaultHTTPResponseHandler: HTTPResponseHandler {
    public init() {}
}
