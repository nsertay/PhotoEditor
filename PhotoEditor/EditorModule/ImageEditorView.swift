//
//  TextEditorView.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 18.09.2024.
//

import SwiftUI
import PencilKit

struct ImageEditorView: View {
    @StateObject private var viewModel = ImageEditorViewModel()
    @State private var isImagePickerPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var showSaveActionSheet = false
    @State private var showEditActionSheet = false
    @State private var showTextEditor = false
    @State private var showCanvas = false
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(viewModel.scale)
                        .rotationEffect(viewModel.rotation)
                        .gesture(MagnificationGesture()
                            .onChanged { value in
                                viewModel.scale = value
                            }
                        )
                        .gesture(RotationGesture()
                            .onChanged { value in
                                viewModel.rotation = value
                            }
                        )
                        .padding()
                    
                    if showCanvas {
                        CanvasView(canvasView: $viewModel.canvasView)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                viewModel.setupCanvas()
                            }
                    }
                    
                    Text(viewModel.text)
                        .font(Font(viewModel.textAttributes.font))
                        .foregroundColor(Color(viewModel.textAttributes.color))
                        .position(viewModel.textPosition)
                        .gesture(DragGesture()
                            .onChanged { value in
                                viewModel.textPosition = value.location
                            }
                        )
                }
            } else {
                Text("Select an Image")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button("Select Image") {
                showActionSheet = true
            }
            .padding()
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Choose Image Source"), buttons: [
                    .default(Text("Camera")) {
                        sourceType = .camera
                        isImagePickerPresented = true
                    },
                    .default(Text("Photo Library")) {
                        sourceType = .photoLibrary
                        isImagePickerPresented = true
                    },
                    .cancel()
                ])
            }
            
            Button("Save Photo") {
                showSaveActionSheet = true
            }
            .padding()
            .actionSheet(isPresented: $showSaveActionSheet) {
                ActionSheet(title: Text("Save Image As"), buttons: [
                    .default(Text("Original")) {
                        viewModel.saveImage(imageType: .original)
                    },
                    .default(Text("Instagram")) {
                        viewModel.saveImage(imageType: .instagram)
                    },
                    .default(Text("Facebook")) {
                        viewModel.saveImage(imageType: .facebook)
                    },
                    .cancel()
                ])
            }
            
            Button("Edit Image") {
                showEditActionSheet = true
            }
            .padding()
            .actionSheet(isPresented: $showEditActionSheet) {
                ActionSheet(title: Text("Edit Image"), buttons: [
                    .default(Text("Draw with PencilKit")) {
                        showCanvas = true
                    },
                    .default(Text("Apply Filter")) {
                        viewModel.applyFilterToImage()
                    },
                    .default(Text("Add Text")) {
                        showTextEditor = true
                    },
                    .cancel()
                ])
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.image, sourceType: sourceType, allowsEditing: true)
        }
        .sheet(isPresented: $showTextEditor) {
            TextEditorView(viewModel: viewModel)
        }
        .navigationTitle("Image Editor")
        .navigationBarTitleDisplayMode(.inline)
    }
}
