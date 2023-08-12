//
//  ChoosePhotoView.swift
//  QRArtGenerator
//
//  Created by khac tao on 02/08/2023.
//

import SwiftUI
import UIKit

class TLCoordinator: NSObject, TLPhotosPickerViewControllerDelegate {
    var parent: ChoosePhotoView
    
    init(_ parent: ChoosePhotoView) {
        self.parent = parent
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        let image = withTLPHAssets.first?.fullResolutionImage
    }
    
    func dismissPhotoPicker(qrString: String, sourceImage: UIImage) {
        parent.didSelectPhoto?(qrString, sourceImage)
    }
}

struct ChoosePhotoView: UIViewControllerRepresentable {
    
    var didSelectPhoto: ((String, UIImage) -> Void)?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = TLPhotosPickerViewController()
        controller.configure.allowedVideo = false
        controller.configure.singleSelectedMode = true
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> TLCoordinator {
        TLCoordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
}

