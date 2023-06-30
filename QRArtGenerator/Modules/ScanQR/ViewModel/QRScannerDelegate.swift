//
//  QRScannerDelegate.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import Foundation
import AVKit

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @Published var scannerCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let code = readableObject.stringValue else { return }
            if code != scannerCode {
                scannerCode = code
            }
           
        }
    }
}
