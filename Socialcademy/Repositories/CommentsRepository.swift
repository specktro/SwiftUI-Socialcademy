//
//  CommentsRepository.swift
//  Socialcademy
//
//  Created by specktro on 17/12/24.
//

import Foundation

protocol CommentsRepositoryProtocol {
    var user: User { get }
    var post: Post { get }
    
    func fetchComments() async throws -> [Comment]
    func create(_ comment: Comment) async throws
    func delete(_ comment: Comment) async throws
}

extension CommentsRepositoryProtocol {
    func canDelete(_ comment: Comment) -> Bool {
        [comment.author.id, post.author.id].contains(user.id)
    }
}

#if DEBUG
struct CommentsRepositoryStub: CommentsRepositoryProtocol {
    let user = User.testUser
    let post = Post.testPost
    let state: Loadable<[Comment]>
    
    func fetchComments() async throws -> [Comment] {
        return try await state.simulate()
    }
    func create(_ comment: Comment) async throws {}
    
    func delete(_ comment: Comment) async throws {}
}
#endif
