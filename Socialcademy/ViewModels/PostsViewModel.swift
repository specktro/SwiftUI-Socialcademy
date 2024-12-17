//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import SwiftUI

@MainActor
final class PostsViewModel: ObservableObject {
    enum Filter {
        case all
        case favorites
    }
    
    private let postsRepository: PostsRepositoryProtocol
    private let filter: Filter
    @Published var posts: Loadable<[Post]> = .loading
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        }
    }
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    func fetchPost() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
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
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(
            post: post,
            deleteAction: { [weak self] in
                try await self?.postsRepository.delete(post)
                self?.posts.value?.removeAll { $0 == post }
            },
            favoriteAction: { [weak self] in
                let newValue = !post.isFavorite
                try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
                guard let i = self?.posts.value?.firstIndex(of: post) else { return }
                self?.posts.value?[i].isFavorite = newValue
            }
        )
    }
    
    func makeNewPostViewModel() -> FormViewModel<Post> {
        return FormViewModel(
            initialValue: Post(title: "", content: "", author: postsRepository.user),
            action: { [weak self] post in
                try await self?.postsRepository.create(post)
                self?.posts.value?.insert(post, at: 0)
            }
        )
    }
}

private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
