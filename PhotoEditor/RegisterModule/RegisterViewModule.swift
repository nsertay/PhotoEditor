//
//  RegisterViewModule.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import Combine
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isRegistered = false  // To indicate successful registration

    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService())  {
        self.authService = authService
    }
    
    func register() {
        guard validateEmail(email), validatePassword(password, confirmPassword) else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        authService.createProfile(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    self?.isRegistered = true  // Registration successful
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // Register with Google
    func registerWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        authService.signInWithGoogle()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    self?.isRegistered = true  // Registration successful
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // Email validation
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !predicate.evaluate(with: email) {
            errorMessage = "Invalid email address."
            return false
        }
        return true
    }
    
    // Password validation
    private func validatePassword(_ password: String, _ confirmPassword: String) -> Bool {
        if password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Password fields cannot be empty."
            return false
        }
        
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        
        return true
    }
}
