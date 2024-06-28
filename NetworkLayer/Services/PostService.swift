//
//  PostService.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

import Foundation

struct PostRequest: NetworkRequest {
    let url: URL?
    let method: HTTPMethod
    let headers: [HTTPHeader: String]?
    let parameters: Encodable?
    let timeOutInterval: TimeInterval
    
    init() {
        self.url = URL(string: "https://2e84f9d6-0dcb-4b93-9238-8b272604b4c1.mock.pstmn.io/v1/posts")
        self.method = .get
        self.headers = [.contentType: ContentType.json.rawValue]
        self.parameters = nil
        self.timeOutInterval = 30
    }
}

class PostService {
    private let networkEngine: NetworkEngineAdapter
    
    init(networkEngine: NetworkEngineAdapter = NetworkEngine()) {
        self.networkEngine = networkEngine
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], NetworkError>) -> Void) {
        let request = PostRequest()
        
        networkEngine.invokeEngine(request, decodeTo: [Post].self) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

