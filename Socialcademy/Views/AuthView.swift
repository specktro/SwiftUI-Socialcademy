//
//  AuthView.swift
//  Socialcademy
//
//  Created by specktro on 16/12/24.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            MainTabView()
        } else {
            Form {
                TextField("Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
                Button("Sign In") {
                    viewModel.signIn()
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
