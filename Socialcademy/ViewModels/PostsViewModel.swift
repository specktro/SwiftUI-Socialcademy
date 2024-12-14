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
}
