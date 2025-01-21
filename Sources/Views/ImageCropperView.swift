//
//  ImageCropperView.swift
//  PhotoPickerSwiftUI
//
//  Created by MacBook Pro on 20/01/2025.
//

import SwiftUI
import Mantis

struct ImageCropperView: UIViewControllerRepresentable{
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> CropViewController {
        var config = Mantis.Config()
        config.cropToolbarConfig.toolbarButtonOptions = [.clockwiseRotate , .counterclockwiseRotate , .reset]

        let cropViewController = Mantis.cropViewController(image: image!, config: config)
        
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
            parent.image = cropped

        }
        
        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
            
        }
        
        var parent: ImageCropperView
        
        init(_ parent: ImageCropperView) {
            self.parent = parent
        }
        
        @MainActor func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
            //MARK: - Success
                parent.image =  cropped
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
