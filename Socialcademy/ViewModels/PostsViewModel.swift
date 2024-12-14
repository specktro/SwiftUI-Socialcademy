//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import SwiftUI

@MainActor
final class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = [Post.testPost]
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            self?.posts.insert(post, at: 0)
        }
    }
}
