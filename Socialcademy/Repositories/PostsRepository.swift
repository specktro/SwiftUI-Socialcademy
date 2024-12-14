//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by specktro on 14/12/24.
//

import FirebaseFirestore
import Foundation

struct PostsRepository {
    static let postsReference = Firestore.firestore().collection("posts")
    
    static func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
