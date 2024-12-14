//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by specktro on 13/12/24.
//

import SwiftUI

struct NewPostForm: View {
    typealias CreateAction = (Post) -> Void
    let createAction: CreateAction
    
    @Environment(\.dismiss) private var dismiss
    @State private var post = Post(title: "", content: "", authorName: "")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                
                Section("Content") {
                    TextEditor(text: $post.content)
                        .multilineTextAlignment(.leading)
                }
                
                Button {
                    createPost()
                } label: {
                    Text("Create Post")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(createPost)
            .navigationTitle("New Post")
        }
    }
    
    private func createPost() {
        createAction(post)
        dismiss()
    }
}

#Preview {
    NewPostForm(createAction: { _ in })
}
