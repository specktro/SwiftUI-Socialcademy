//
//  ProfileView.swift
//  Socialcademy
//
//  Created by specktro on 16/12/24.
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                AsyncImage(url: viewModel.imageURL)
                    .frame(width: 200, height: 200)
                Spacer()
                Text(viewModel.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ImagePickerButton(imageURL: $viewModel.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Spacer()
            }
        }
        .navigationTitle("Profile")
        .toolbar {
            Button("Sign Out", action: {
                viewModel.signOut()
            })
        }
        .alert("Error", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(user: User.testUser, authService: AuthService()))
}
