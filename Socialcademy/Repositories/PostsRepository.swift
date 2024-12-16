//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import FirebaseFirestore
import Foundation

protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchPosts() async throws -> [Post]
    func delete(_ post: Post) async throws
}

struct PostsRepository: PostsRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts")
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func fetchPosts() async throws -> [Post] {
        let snapshot = try await postsReference
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    
    func create(_ post: Post) async throws {}
    
    func fetchPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func delete(_ post: Post) async throws {}
}
#endif
