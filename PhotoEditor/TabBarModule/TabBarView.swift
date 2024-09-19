//
//  TabBarView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 16.09.2024.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationView {
                ImageEditorView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
