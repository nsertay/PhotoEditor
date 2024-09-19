//
//  LoginView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Email input field
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1))
                .padding(.horizontal)
                .accessibility(label: Text("Email"))
            
            // Password input field
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1))
                .padding(.horizontal)
                .accessibility(label: Text("Password"))
            
            // Error message
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .accessibility(label: Text("Error: \(errorMessage)"))
            }
            
            // Loading indicator or buttons
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .accessibility(label: Text("Loading"))
            } else {
                // Login with Email button
                Button(action: {
                    viewModel.loginWithEmail()
                }) {
                    Text("Login with Email")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal)
                .accessibility(label: Text("Login with Email"))

                Spacer()
                Button(action: {
                    viewModel.loginWithGoogle()
                }) {
                    Text("Sign in with Google")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemRed))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal)
                .accessibility(label: Text("Sign in with Google"))
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Sign up")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBlue))
                        .padding()
                }
                .accessibility(label: Text("Sign up"))
            }
        }
        .padding()
        .navigationTitle("Login")
        .alert(isPresented: $showAlert, title: alertTitle, message: alertMessage)
    }
}
