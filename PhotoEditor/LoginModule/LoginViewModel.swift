//
//  LoginViewModel.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Dependency injection for AuthService
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func loginWithEmail() {
        guard validateEmail(email), !password.isEmpty else {
            errorMessage = "Please enter a valid email and password."
            return
        }
        
        isLoading = true
        authService.signInWithEmail(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                // Handle successful login, e.g., navigate to the main app screen
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
    
    func loginWithGoogle() {
        isLoading = true
        authService.signInWithGoogle()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { _ in
                // Handle successful login, e.g., navigate to the main app screen
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
