//
//  PostRow.swift
//  Socialcademy
//
//  Created by specktro on 13/12/24.
//

import SwiftUI

struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack {
            Text(post.authorName)
            Text(post.timestamp.formatted())
            Text(post.title)
            Text(post.content)
        }
    }
}

#Preview {
    PostRow(post: Post.testPost)
}
