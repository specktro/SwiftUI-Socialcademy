//
//  CommentsViewModel.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

import SwiftUI

@MainActor
final class CommentsViewModel: ObservableObject {
    @Published var comments: Loadable<[Comment]> = .loading
    
    private let commentsRepository: CommentsRepositoryProtocol
    
    init(commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    func fetchComments() {
        Task {
            do {
                comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Cannot fetch comments: \(error)")
                comments = .error(error)
            }
        }
    }
    
    func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment>(
            initialValue: Comment(content: "", author: commentsRepository.user),
            action: { [weak self] comment in
                try await self?.commentsRepository.create(comment)
                self?.comments.value?.insert(comment, at: 0)
            }
        )
    }
}
