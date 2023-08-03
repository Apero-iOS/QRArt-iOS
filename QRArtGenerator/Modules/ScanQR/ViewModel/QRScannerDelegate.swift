//
//  QRScannerDelegate.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import Foundation
import AVKit
import Vision

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var scannerCode: String?
    private let sequenceHandler = VNSequenceRequestHandler()
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        if let barcode = self.extractQRCode(fromFrame: frame) {
            if barcode != scannerCode {
                scannerCode = barcode
            }
        }
    }
    
    private func extractQRCode(fromFrame frame: CVImageBuffer) -> String? {
        let barcodeRequest = VNDetectBarcodesRequest()
        barcodeRequest.symbologies = [.qr]
        try? self.sequenceHandler.perform([barcodeRequest], on: frame)
        guard let results = barcodeRequest.results, let firstBarcode = results.first?.payloadStringValue else {
            return nil
        }
        return firstBarcode
    }
    
    
}
