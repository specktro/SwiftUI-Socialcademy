//
//  ProfileViewModel.swift
//  Socialcademy
//
//  Created by specktro on 21/12/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject, StateManager {
    @Published var name: String
    @Published var error: Error?
    @Published var isWorking = false
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    
    private let authService: AuthService
    
    init(user: User, authService: AuthService) {
        self.name = user.name
        self.imageURL = user.imageURL
        self.authService = authService
    }
    
    func signOut() {
        withStateManagingTask(perform: authService.signOut)
    }
    
    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withStateManagingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}
