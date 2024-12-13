//
//  PostsList.swift
//  Socialcademy
//
//  Created by specktro on 13/12/24.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]
    
    var body: some View {
        List(posts) { post in
            Text(post.content)
        }
    }
}

#Preview {
    PostsList()
}
