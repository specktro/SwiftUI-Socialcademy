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
    @StateObject var viewModel: PostsViewModel
    
    var body: some View {
        Group {
            switch viewModel.posts {
            case .loading:
                ProgressView()
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Posts",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchPost()
                    }
                )
            case .empty:
                EmptyListView(
                    title: "No Posts",
                    message: "There aren't any posts yet."
                )
            case let .loaded(posts):
                ScrollView {
                    ForEach(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.fetchPost()
        }
        .toolbar {
            Button {
                showNewPostForm = true
            } label: {
                Label("New Post", systemImage: "square.and.pencil")
            }
        }
        .sheet(isPresented: $showNewPostForm) {
            NewPostForm(viewModel: viewModel.makeNewPostViewModel())
        }
    }
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            NavigationView {
                PostsList(viewModel: viewModel)
            }
        }
    }
}
#endif
