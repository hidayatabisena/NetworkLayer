//
//  PostVM.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadPosts() {
        isLoading = true
        
        Task {
            do {
                let posts = try await APIService.shared.fetchPosts()
                self.posts = posts
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}




