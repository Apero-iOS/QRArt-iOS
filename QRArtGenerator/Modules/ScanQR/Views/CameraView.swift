//
//  CameraView.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    var frameSize: CGSize
    
    //Camera Sessiom
    @Binding var session: AVCaptureSession
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
