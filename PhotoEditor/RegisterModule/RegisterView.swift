//
//  RegisterView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = RegisterViewModel()
    @State private var showingLoginView = false
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
            
            // Confirm Password input field
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1))
                .padding(.horizontal)
                .accessibility(label: Text("Confirm Password"))
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
                    .accessibility(label: Text("Loading"))
            } else {
                Spacer()
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal)
                .accessibility(label: Text("Register"))
                
                Button(action: {
                    viewModel.registerWithGoogle()
                }) {
                    Text("Register with Google")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemRed))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal)
                .accessibility(label: Text("Register with Google"))
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Already have an account? Sign in")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemBlue))
                        .padding()
                }
                .accessibility(label: Text("Sign in"))
            }
        }
        .padding()
        .navigationTitle("Register")
        .sheet(isPresented: $showingLoginView) {
            LoginView()
        }
        .alert(isPresented: $showAlert, title: alertTitle, message: alertMessage)
    }
}
