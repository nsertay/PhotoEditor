//
//  ProfileViewModel.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var isSignedOut: Bool = false
    @Published var errorMessage: String? = nil
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func signOut() {
        authService.signOut()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Handle successful sign out if needed
                    self?.isSignedOut = true
                case .failure(let error):
                    // Handle sign out error
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { _ in
                // No additional value expected
            })
            .store(in: &cancellables)
    }
}

