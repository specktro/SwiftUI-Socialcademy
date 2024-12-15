//
//  PostsList.swift
//  Socialcademy
//
//  Created by specktro on 13/12/24.
//

import SwiftUI

struct PostsList: View {
    @State private var showNewPostForm: Bool = false
    @State private var searchText: String = ""
    @StateObject private var viewModel: PostsViewModel = PostsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    VStack {
                        Text("Cannot Load Posts")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text(error.localizedDescription)
                        Button {
                            viewModel.fetchPost()
                        } label: {
                            Text("Try Again")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.secondary))
                        }
                        .padding(.top)
                    }
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                case .empty:
                    VStack(alignment: .center, spacing: 10) {
                        Text("No Posts")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("There aren't any posts yet.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(post: post)
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
            .sheet(isPresented: $showNewPostForm) {
                NewPostForm(createAction: viewModel.makeCreateAction())
            }
        }
        .onAppear {
            viewModel.fetchPost()
        }
    }
}

#Preview {
    PostsList()
}
