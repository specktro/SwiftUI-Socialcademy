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
            NavigationView {
                SignInForm(viewModel: viewModel.makeSignInViewModel()) {
                    NavigationLink(
                        "Create Account",
                        destination: CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel())
                    )
                }
            }
        }
    }
}

private extension AuthView {
    struct CreateAccountForm: View {
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        
        var body: some View {
            Form {
                TextField("Name", text: $viewModel.name)
                TextField("Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
                Button("Create Account", action: viewModel.submit)
            }
            .navigationTitle("Create Account")
        }
    }
    
    struct SignInForm<Footer: View>: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            Form {
                TextField("Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
                Button("Sign In", action: viewModel.submit)
                footer()
            }
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthView()
}
