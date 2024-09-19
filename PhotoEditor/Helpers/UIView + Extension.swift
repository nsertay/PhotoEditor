//
//  UIView + Extension.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 18.09.2024.
//

import SwiftUI

extension View {
    func alert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
}
