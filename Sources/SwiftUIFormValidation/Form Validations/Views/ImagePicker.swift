////
////  ImagePicker.swift
////  Recomdy
////
////  Created by Jc Briones on 9/3/22.
////  Copyright © 2022 Recomdy, LLC. All rights reserved.
////
//
//import SwiftUI
//#if canImport(UIKit)
//import UIKit
//#elseif canImport(AppKit)
//import AppKit
//#endif
//
//public struct ImagePicker: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) private var presentationMode
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @Binding var selectedImage: Image?
//
//    public func makeUIViewController(
//        context: UIViewControllerRepresentableContext<ImagePicker>
//    ) -> UIImagePickerController {
//
//        let imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = sourceType
//        imagePicker.delegate = context.coordinator
//
//        return imagePicker
//    }
//
//    public func updateUIViewController(
//        _ uiViewController: UIImagePickerController,
//        context: UIViewControllerRepresentableContext<ImagePicker>
//    ) {
//
//    }
//
//    public func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        public func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
//        ) {
//
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                parent.selectedImage = Image(uiImage: image)
//            }
//
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//    }
//}
