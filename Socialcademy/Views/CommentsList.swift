//
//  CommentsList.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

import SwiftUI

struct CommentsList: View {
    @StateObject var viewModel: CommentsViewModel
    
    var body: some View {
        VStack {
            switch viewModel.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.fetchComments()
                    }
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Comments",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchComments()
                    }
                )
            case .empty:
                EmptyListView(
                    title: "No Comments",
                    message: "Be the first to leave a comment."
                )
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(viewModel: viewModel.makeCommentRowViewModel(for: comment))
                }
                .animation(.default, value: comments)
            }
            Spacer()
            NewCommentForm(viewModel: viewModel.makeNewCommentViewModel())
                .padding()
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension CommentsList {
    struct NewCommentForm: View {
        @StateObject var viewModel: FormViewModel<Comment>
        
        var body: some View {
            HStack {
                TextField("Comment", text: $viewModel.content)
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Label("Post", systemImage: "paperplane")
                    }
                }
            }
            .alert("Cannot Post Comment", error: $viewModel.error)
            .animation(.default, value: viewModel.isWorking)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}

#if DEBUG
struct CommentsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Comment.testComment]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    private struct ListPreview: View {
        let state: Loadable<[Comment]>
        
        var body: some View {
            NavigationView {
                CommentsList(viewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: state)))
            }
        }
    }
}
#endif
