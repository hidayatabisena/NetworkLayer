//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case dataNotFound
    case decodingFailed(DecodingError)
    case encodingFailed(Error)
    case notFound
    case timeout
    case internalServerError
    case unknownError(statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "The request failed with error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid."
        case .dataNotFound:
            return "No data was found."
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.message)"
        case .encodingFailed(let error):
            return "Failed to encode data: \(error.localizedDescription)"
        case .notFound:
            return "The requested resource was not found."
        case .timeout:
            return "The request timed out."
        case .internalServerError:
            return "The server encountered an internal error."
        case .unknownError(let statusCode):
            return "An unknown error occurred with status code: \(statusCode)"
        }
    }
}

struct DecodingError: Error {
    let message: String
}
