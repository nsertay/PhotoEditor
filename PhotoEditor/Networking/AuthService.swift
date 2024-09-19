//
//  AuthService.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import FirebaseAuth
import GoogleSignIn
import Combine
import FirebaseCore

protocol AuthServiceProtocol {
    func signInWithEmail(email: String, password: String) -> AnyPublisher<Void, Error>
    func createProfile(email: String, password: String) -> AnyPublisher<Void, Error>
    func signInWithGoogle() -> AnyPublisher<Void, Error>
    func signOut() -> AnyPublisher<Void, Error>  // New method for signing out
}


class AuthService: AuthServiceProtocol, ObservableObject {
    @Published var isUserSignedIn: Bool = false
        
    init() {
        self.isUserSignedIn = Auth.auth().currentUser != nil
        
        Auth.auth().addStateDidChangeListener { _, user in
            self.isUserSignedIn = user != nil
        }
    }
    
    func signInWithEmail(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signInWithGoogle() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                promise(.failure(NSError(domain: "Missing Google Client ID", code: 0, userInfo: nil)))
                return
            }
            
            let config = GIDConfiguration(clientID: clientID)
            
            guard let presentingVC = UIApplication.shared.windows.first?.rootViewController else {
                promise(.failure(NSError(domain: "Missing root view controller", code: 0, userInfo: nil)))
                return
            }
            
            GIDSignIn.sharedInstance.configuration = config
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC, completion: { result, error in
                if let error = error {
                    print("Error during Google Sign-In: \(error.localizedDescription)")
                    promise(.failure(error))
                    return
                }
                
                guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                    print("User or ID Token not found")
                    promise(.failure(NSError(domain: "User or ID Token not found", code: 0, userInfo: nil)))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            })
        }
        .eraseToAnyPublisher()
    }


    
    func createProfile(email: String, password: String) -> AnyPublisher<Void, Error> {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            return Fail(error: NSError(domain: "Invalid registration data", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return Future<Void, Error> { promise in
            // Create a new user with email and password
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                } else {
                    
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
           return Future<Void, Error> { promise in
               do {
                   try Auth.auth().signOut()
                   promise(.success(()))
               } catch {
                   promise(.failure(error))
               }
           }
           .eraseToAnyPublisher()
       }
}
