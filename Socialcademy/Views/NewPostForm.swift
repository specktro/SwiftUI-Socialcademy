//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by specktro on 13/12/24.
//

import SwiftUI

struct NewPostForm: View {
    typealias CreateAction = (Post) async throws -> Void
    
    @StateObject var viewModel: FormViewModel<Post>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                }
                
                Section("Content") {
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                
                Button {
                    viewModel.submit()
                } label: {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(viewModel.submit)
            .navigationTitle("New Post")
            .disabled(viewModel.isWorking)
            .alert("Cannot Create Post", error: $viewModel.error)
            .onChange(of: viewModel.isWorking) { isWorking in
                guard !isWorking, viewModel.error == nil else { return }
                dismiss()
            }
        }
    }
}

#Preview {
    NewPostForm(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in }))
}
