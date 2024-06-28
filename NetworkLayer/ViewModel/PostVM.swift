//
//  PostVM.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String? = nil
    
    private let postService: PostService
    private var cancellables = Set<AnyCancellable>()
    
    init(postService: PostService = PostService()) {
        self.postService = postService
    }
    
    func fetchPosts() {
        postService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
                }
            }
        }
    }
}



