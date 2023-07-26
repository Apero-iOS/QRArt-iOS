//
//  ScannerViewModel.swift
//  QRArtGenerator
//
//  Created by khac tao on 27/06/2023.
//

import SwiftUI
import AVKit
import NetworkExtension
import MessageUI

class ScannerViewModel: ObservableObject {
    
    var sizeRectangle = 0.05
    var paddinRectangle: CGFloat = 25
    let cameraLayer = AVCaptureVideoPreviewLayer()
    lazy var deveice: AVCaptureDevice? = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
    
    @Published var isScanning: Bool = false
    @Published var session: AVCaptureSession = .init()
    @Published var qrOutput: AVCaptureVideoDataOutput = .init()
    @Published var cameraPermission: CameraPermission = .idle
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var scannerCode: String?
    @Published var cameraSize: CGSize = .zero
    @Published var showSheet: Bool = false
    @Published var zoomValue: CGFloat = 1
    @Published var torchMode: AVCaptureDevice.TorchMode = .off
    @Published var frameCamera: CGRect = .zero
    @Published var qrItem: ResultQR = ResultQR(type: .text, content: "", title: "")
    @Published var toastMessage: String?
    @Published var isShowToast: Bool = false
    @Published var isShowSendMessage: Bool = false
    @Published var isShowWebView: Bool = false
    @Published var isShowShareActivity: Bool = false
    @Published var showPopupAccessCamera: Bool = false
  
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
            qrItem = QRHelper.parseResultQR(text: code)
            showSheet = true
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
        guard let deveice = deveice else {
            presentError(Rlocalizable.unknow_error())
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
        guard let deveice = deveice else {
            presentError(Rlocalizable.unknow_error())
            return
        }
        do {
            if value <= deveice.maxAvailableVideoZoomFactor,
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

extension ScannerViewModel {

    func handleResult(item: ResultQR, actiontype: QRActionType) {
        switch actiontype {
        case .connectWifi:
            connectWifi(item: item)
        case .copyText:
            copyText(text: item.content)
        case .phoneMessage:
            phoneMessage()
        case .phoneCall:
            phoneCall(numberString: item.content)
        case .openMail:
            openMail(item: item)
        case .openUrl:
            openUrl(urlString: item.content)
        }
    }
    
    func connectWifi(item: ResultQR) {
        let dict_code = item.dictionary
        let wifiData = WifiData(dict: dict_code)
        QRHelper.connectWifi(data: wifiData) { [weak self] status, message in
            self?.showToast(message: message)
        }
    }
    
    func copyText(text: String) {
        UIPasteboard.general.string = text
        showToast(message: Rlocalizable.copy_success())
    }
    
    func phoneCall(numberString: String) {
        let telephone = "tel://"
        let formattedString = telephone + numberString
        guard let url = URL(string: formattedString) else { return }
        UIApplication.shared.open(url)
    }
    
    func phoneMessage() {
        isShowSendMessage.toggle()
    }
    
    func openMail(item: ResultQR) {
        let mailData = MailData.init(dict: item.dictionary)
        QRHelper.sendMail(data: mailData)
    }
    
    func openUrl(urlString: String) {
        UIApplication.shared.open(URL(string: urlString)!)
    }
    
    func showToast(message: String) {
        toastMessage = message
        isShowToast.toggle()
    }
}
