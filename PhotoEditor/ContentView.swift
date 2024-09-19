//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var authService = AuthService()
    
    var body: some View {
        Group {
            if authService.isUserSignedIn {
                TabBarView()
            } else {
                NavigationView {
                    LoginView()
                        .navigationTitle("Login")
                }
            }
        }
        .onAppear {
        
        }
    }
}
