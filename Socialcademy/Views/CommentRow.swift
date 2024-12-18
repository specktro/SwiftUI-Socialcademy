//
//  CommentRow.swift
//  Socialcademy
//
//  Created by specktro on 18/12/24.
//

import SwiftUI

struct CommentRow: View {
    @ObservedObject var viewModel: CommentRowViewModel
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(viewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(viewModel.timestamp.formatted())
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text(viewModel.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
        .swipeActions {
            if viewModel.canDeleteComment {
                Button(role: .destructive) {
                    viewModel.deleteComment()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CommentRow(viewModel: CommentRowViewModel(comment: Comment.testComment, deleteAction: {}))
}
