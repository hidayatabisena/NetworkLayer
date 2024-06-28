//
//  NetworkRequest.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case formUrlEncoded = "application/x-www-form-urlencoded"
}

protocol NetworkRequest {
    var url: URL? { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader: String]? { get }
    var parameters: Encodable? { get }
    var timeOutInterval: TimeInterval { get }
}

enum APIEndpoint: String {
    case posts = "https://2e84f9d6-0dcb-4b93-9238-8b272604b4c1.mock.pstmn.io/v1/posts"
}
