//
//  ContentView.swift
//  NetworkLayer
//
//  Created by Hidayat Abisena on 28/06/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var postVM = PostViewModel()
    
    var body: some View {
        NavigationView {
            List(postVM.posts) { post in
                CardView(post: post)
                    //.padding(.vertical, 8)
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .overlay(
                Group {
                    if postVM.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
            )
            .alert(isPresented: Binding<Bool>(
                get: { postVM.errorMessage != nil },
                set: { _ in postVM.errorMessage = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(postVM.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            postVM.loadPosts()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PostViewModel())
}
