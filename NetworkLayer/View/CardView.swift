//
//  CardView.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import SwiftUI

struct CardView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: post.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(height: 200)
            }
            
            Group {
                Text(post.title)
                    .font(.headline)
                
                Text(post.description)
                    .font(.subheadline)
            }
            .foregroundStyle(.primary)
            
        }
        .padding()
        .background(Color.yellow.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}


#Preview {
    CardView(post: Post.example)
}
