//
//  Post.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import Foundation

struct Post: Codable, Identifiable {
    let id = UUID()
    let title: String
    let url: String
    let height: Int
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case title, url, height, description
    }
    
    static let example = Post(
        title: "Sample Post",
        url: "https://picsum.photos/400",
        height: 150,
        description: "This is a sample post description."
    )
}


