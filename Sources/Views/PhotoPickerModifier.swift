//
//  PhotoPickerModifier.swift
//  PhotoPickerSwiftUI
//
//  Created by MacBook Pro on 20/01/2025.
//

import SwiftUI
import PhotosUI

struct PhotoPickerModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var image: Image?
    let showDeleteButton: Bool

    @State private var selectedItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var openPicEditor = false
    
    @State private var tempImage: Image?
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                //MARK: - Dissmiss
            } content: {
                VStack(alignment: .leading, spacing: 15){
                    
                    photoPicker()
                    
                    Button {
                        showCamera.toggle()
                    } label: {
                        sheetTile("Take a photo", image: .camera)
                            .foregroundStyle(Color(.label))
                    }
                    .fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$tempImage,
                                         closeSheet: $isPresented,
                                         openPicEditor: $openPicEditor)
                            .background(.black)
                    }
                    
                    if showDeleteButton {
                        Button {
                            isPresented = false
                        } label: {
                            sheetTile("Remove current picture", image: .trash)
                                .foregroundStyle(.red)
                        }
                    }
                    
                }.padding()
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .presentationDetents([.height(140)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(20)
                    .fullScreenCover(isPresented: $openPicEditor ,content: {
                        ImageCropperView(image: $image,
                                         tempImage: $tempImage,
                                         isPresented: $openPicEditor)
                                         //closeSheet: $isPresented)
                    })
                
            }
            
        
    }
    
    @ViewBuilder func photoPicker() -> some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            HStack(alignment: .center, spacing: 10) {
                Image(.gallery)
                    .frame(width: 24, height: 24)
                Text("Choose from library")
                    .font(.system(size: 16, weight: .regular))
            }.foregroundStyle(Color(.label))
        }.onChange(of: selectedItem) {
            self.isPresented = false
            Task {
                if let image = try? await selectedItem?.loadTransferable(type: Image.self) {
                    self.tempImage = image
                    self.openPicEditor = true
                }
                
            }
        }
    }
    
    @ViewBuilder func sheetTile(_ title: String, image: ImageResource) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Image(image)
                .frame(width: 24, height: 24)
            Text(title)
                .font(.system(size: 16, weight: .regular))
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    @Previewable  @State var image: Image? = nil

    VStack{}.photoPicker(isPresented: $isPresented, image: $image)
}

// MARK: - Extension
// Extension for adding the authentication sheet modifier to any view
extension View {
    public func photoPicker(isPresented: Binding<Bool>, image: Binding<Image?> , showDeleteButton: Bool = true) -> some View {
        modifier(PhotoPickerModifier(isPresented: isPresented,
                                     image: image,
                                     showDeleteButton: showDeleteButton))
    }
}


