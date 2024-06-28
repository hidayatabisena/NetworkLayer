//
//  PostService.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

struct Constants {
    static let baseURL = "https://2e84f9d6-0dcb-4b93-9238-8b272604b4c1.mock.pstmn.io/v1/posts"
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: Constants.baseURL) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.requestFailed
        }
        
        do {
            let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
            return decodedPosts
        } catch {
            throw APIError.decodingFailed
        }
    }
}



