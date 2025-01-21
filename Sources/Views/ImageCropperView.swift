//
//  ImageCropperView.swift
//  PhotoPickerSwiftUI
//
//  Created by MacBook Pro on 20/01/2025.
//

import SwiftUI
import Mantis

struct ImageCropperView: UIViewControllerRepresentable{
    @Binding var image: Image?
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate , .counterclockwiseRotate , .reset]
       
            let cropViewController = Mantis.cropViewController(image: image!.asUIImage(), config: config)
            cropViewController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio:  4 / 4)
            cropViewController.delegate = context.coordinator
            return cropViewController
        
       
    }
    
    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, @preconcurrency CropViewControllerDelegate {
        let cropQueue = DispatchQueue(label: "com.example.cropQueue")

        @MainActor func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController,
                                       cropped: UIImage,
                                       transformation: Mantis.Transformation,
                                       cropInfo: Mantis.CropInfo) {
            //MARK: - Success
            parent.image = Image(uiImage: cropped)

        }
        
        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
            
        }
        
        var parent: ImageCropperView
        
        init(_ parent: ImageCropperView) {
            self.parent = parent
        }
        
        @MainActor func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            //MARK: - Success
            parent.image = Image(uiImage: cropped)
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
            //MARK: - Failed
        }
        
        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
            //MARK: - Failed
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {}
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
