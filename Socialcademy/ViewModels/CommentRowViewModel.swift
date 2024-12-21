//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

import SwiftUI

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager {
    typealias Action = () async throws -> Void
    
    @Published var comment: Comment
    @Published var error: Error?
    
    var canDeleteComment: Bool { deleteAction != nil }
    private let deleteAction: Action?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        
        withStateManagingTask(perform: deleteAction)
    }
}
