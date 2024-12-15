//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import SwiftUI

@MainActor
final class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
    
    func fetchPost() {
        Task {
            do {
                posts = try await PostsRepository.fetchPosts()
            } catch {
                print("[PostViewModel] Cannot fetch posts: \(error)")
            }
        }
    }
}
