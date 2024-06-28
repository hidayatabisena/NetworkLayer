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
        postService.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch posts: \(error)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancellables)
    }
}

