//
//  ScannerViewModel.swift
//  QRArtGenerator
//
//  Created by khac tao on 27/06/2023.
//

import SwiftUI
import AVKit
import NetworkExtension

class ScannerViewModel: ObservableObject {
    
    var sizeRectangle = 0.05
    var paddinRectangle: CGFloat = 25
    let cameraLayer = AVCaptureVideoPreviewLayer()
    
    @Published var isScanning: Bool = false
    @Published var session: AVCaptureSession = .init()
    @Published var qrOutput: AVCaptureMetadataOutput = .init()
    @Published var cameraPermission: CameraPermission = .idle
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var scannerCode: String?
    @Published var cameraSize: CGSize = .zero
    @Published var showSheet: Bool = false
    @Published var zoomValue = 1.0
    @Published var torchMode: AVCaptureDevice.TorchMode = .off
  
    func tourchClick() {
        if torchMode == .off {
            torchMode = .on
        } else {
            torchMode = .off
        }
    }
    
    func handleQRResult(text: String?) {
        scannerCode = text
        if let code = text {
            let _ = parseResultQR(text: code)
            showSheet.toggle()
        }
    }
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }

    func activeScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    func deActiveScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
}

// MARK: - Setup camera
extension ScannerViewModel {
    
    func updateTorchMode(mode: AVCaptureDevice.TorchMode) {
        guard let deveice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            presentError("Unknown error")
            return
        }
        do {
            if deveice.hasTorch {
                try deveice.lockForConfiguration()
                deveice.torchMode = mode
                deveice.unlockForConfiguration()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func zoomCamera(value: CGFloat) {
        guard let deveice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            presentError("Unknown error")
            return
        }
        do {
            if value <= deveice.maxAvailableVideoZoomFactor ,
               value >= deveice.minAvailableVideoZoomFactor {
                try deveice.lockForConfiguration()
                deveice.videoZoomFactor = value
                deveice.unlockForConfiguration()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Parse result
extension ScannerViewModel {

    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func parseResultQR(text: String) -> ResultQR {
        var arrydict = text.components(separatedBy: ";")
        var result = ResultQR(type: .mail, content: text)
        if arrydict.count > 1 {
            if arrydict[0].starts(with: QRScanType.wifi.rawValue) {
                // QR wifi
                result.type = .wifi
                arrydict[0] = arrydict[0].replacingOccurrences(of: QRScanType.wifi.rawValue, with: "")
                arrydict.forEach { string in
                    let dicArry = string.components(separatedBy: ":")
                    if dicArry.count == 2 {
                        result.dictionary.updateValue(dicArry[1], forKey: dicArry[0])
                    }
                }
            } else if arrydict.first!.starts(with: QRScanType.mail.rawValue) {
                //QR mail
                arrydict[0] = arrydict[0].replacingOccurrences(of: QRScanType.mail.rawValue, with: "")
                result.type = .mail
                arrydict.forEach { string in
                    let dicArry = string.components(separatedBy: ":")
                    if dicArry.count == 2 {
                        result.dictionary.updateValue(dicArry[1], forKey: dicArry[0])
                    }
                }
            } else {
                // QR unknow
                result.type = .text
            }
        } else {
            if isValidPhone(phone: text) {
                // QR phone
                result.type = .phone
            } else if verifyUrl(urlString: text) {
                // QR url
                result.type = .url
            } else {
                // QR text
                result.type = .text
            }
        }
        print("type \(result.type)")
        print("\(result.dictionary)")
        return result
    }
}
