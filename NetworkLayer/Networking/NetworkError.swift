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
    case decodingFailed(Error)
    case encodingFailed(Error)
    case notFound
    case timeout
    case internalServerError
    case unknownError(statusCode: Int)
}

struct DecodingError: Error {
    let message: String
}
