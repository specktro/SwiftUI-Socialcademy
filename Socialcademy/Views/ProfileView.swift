//
//  ProfileView.swift
//  Socialcademy
//
//  Created by specktro on 16/12/24.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}

#Preview {
    ProfileView()
}
