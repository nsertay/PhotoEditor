//
//  ImageEditorViewModel.swift
//  PhotoEditor
//
//  Created by Nurmukhanbet Sertay on 18.09.2024.
//

import SwiftUI
import PencilKit
import CoreImage

// MARK: - ViewModel

class ImageEditorViewModel: ObservableObject {
    @Published var image: UIImage?  // The image being edited
    @Published var scale: CGFloat = 1.0  // Image scale
    @Published var rotation: Angle = .zero  // Image rotation
    @Published var text: String = ""  // Text to add
    @Published var textAttributes: TextAttributes = TextAttributes()  // Text attributes
    @Published var textPosition: CGPoint = CGPoint(x: 100, y: 100)  // Text position

    var canvasView = PKCanvasView()  // Canvas for drawing

    // Enum for image types
    enum ImageType {
        case original, instagram, facebook
    }

    // Struct for text attributes
    struct TextAttributes {
        var font: UIFont = .systemFont(ofSize: 24)
        var color: UIColor = .black
        var alignment: NSTextAlignment = .center
    }

    // Initialize the canvas
    func setupCanvas() {
        guard let image = image else { return }
        canvasView.frame = CGRect(origin: .zero, size: image.size)
        canvasView.drawing = PKDrawing()
    }

    // Save image with optional resizing
    func saveImage(imageType: ImageType) {
        guard let originalImage = image else { return }
        let resizedImage: UIImage?
        
        // Resize image based on type
        switch imageType {
        case .original:
            resizedImage = originalImage
        case .instagram:
            resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 1080, height: 1350))
        case .facebook:
            resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 1200, height: 630))
        }
        
        guard let imageToSave = resizedImage else { return }
        let combinedImage = mergeDrawingWithImage(originalImage: imageToSave)
        saveImageToPhotos(image: combinedImage)
    }

    // Save image to photo library
    private func saveImageToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    // Resize image to target size
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    // Merge drawing and text with the image
    private func mergeDrawingWithImage(originalImage: UIImage) -> UIImage {
        let imageSize = originalImage.size
        let imageRect = CGRect(origin: .zero, size: imageSize)
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.scale = originalImage.scale
        
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        
        return renderer.image { context in
            originalImage.draw(in: imageRect)
            
            // Draw PencilKit drawing
            let drawingRect = CGRect(origin: .zero, size: imageSize)
            let drawingImage = canvasView.drawing.image(from: drawingRect, scale: originalImage.scale)
            drawingImage.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
            
            // Draw text if present
            if !text.isEmpty {
                let textAttributes = [
                    NSAttributedString.Key.font: textAttributes.font,
                    NSAttributedString.Key.foregroundColor: textAttributes.color
                ]
                
                let textSize = text.size(withAttributes: textAttributes)
                let textRect = CGRect(
                    x: textPosition.x * rendererFormat.scale,
                    y: textPosition.y * rendererFormat.scale,
                    width: textSize.width,
                    height: textSize.height
                )
                
                let textRenderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
                let textImage = textRenderer.image { ctx in
                    text.draw(in: textRect, withAttributes: textAttributes)
                }
                textImage.draw(in: imageRect)
            }
        }
    }

    // Apply a sepia filter to the image
    func applyFilterToImage() {
        guard let image = image else { return }
        
        let context = CIContext()
        let ciImage = CIImage(image: image)
        
        if let filter = CIFilter(name: "CISepiaTone") {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(0.8, forKey: kCIInputIntensityKey)
            
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                self.image = UIImage(cgImage: cgImage)
            }
        }
    }
}
