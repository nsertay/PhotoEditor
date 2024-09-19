//
//  ProfileView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                viewModel.signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .fullScreenCover(isPresented: $viewModel.isSignedOut) {
                LoginView() 
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
