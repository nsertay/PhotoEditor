//
//  TextEditorView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 18.09.2024.
//

import SwiftUI

struct TextEditorView: View {
    @ObservedObject var viewModel: ImageEditorViewModel
    @State private var inputText: String = ""
    @State private var selectedFont: UIFont = .systemFont(ofSize: 24)
    @State private var selectedColor: UIColor = .black
    @State private var selectedAlignment: NSTextAlignment = .center
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Text")) {
                    TextField("Enter text", text: $inputText)
                }
                
                Section(header: Text("Font")) {
                    Picker("Font", selection: $selectedFont) {
                        Text("System").tag(UIFont.systemFont(ofSize: 24))
                        Text("Bold").tag(UIFont.boldSystemFont(ofSize: 24))
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Select Color", selection: Binding(
                        get: { Color(selectedColor) },
                        set: { selectedColor = UIColor($0) }
                    ))
                }
                
                Section(header: Text("Alignment")) {
                    Picker("Alignment", selection: $selectedAlignment) {
                        Text("Left").tag(NSTextAlignment.left)
                        Text("Center").tag(NSTextAlignment.center)
                        Text("Right").tag(NSTextAlignment.right)
                    }
                }
                
                Button("Apply") {
                    viewModel.text = inputText
                    viewModel.textAttributes = ImageEditorViewModel.TextAttributes(
                        font: selectedFont,
                        color: selectedColor,
                        alignment: selectedAlignment
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Text Editor")
            .navigationBarItems(trailing: Button("Done") {
                viewModel.text = inputText
                viewModel.textAttributes = ImageEditorViewModel.TextAttributes(
                    font: selectedFont,
                    color: selectedColor,
                    alignment: selectedAlignment
                )
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
