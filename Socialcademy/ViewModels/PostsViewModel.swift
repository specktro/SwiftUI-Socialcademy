//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import SwiftUI

@MainActor
final class PostsViewModel: ObservableObject {
    private let postsRepository: PostsRepositoryProtocol
    @Published var posts: Loadable<[Post]> = .loading
    
    init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.postsRepository = postsRepository
    }
    
    func fetchPost() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts())
            } catch {
                print("[PostViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
    
    func makeDeleteAction(for post: Post) -> PostRow.DeleteAction {
        return { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll(where: { $0.id == post.id })
        }
    }
}
