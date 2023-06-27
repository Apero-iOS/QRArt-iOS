//
//  ScannerView.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import AVKit
import BottomSheet

struct ScannerView: View {
    private var sizeRectangle = 0.05
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var cameraPermission: CameraPermission = .idle
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @StateObject private var qrDelegate = QRScannerDelegate()
    @StateObject private var viewModel = ScannerViewModel()
    @State private var scannerCode: String?
    @State var cameraSize: CGSize = .zero
    @State var showSheet: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .center) {
                makeCameraView(size: size)
             
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5))
                        .ignoresSafeArea()
                    Rectangle()
                        .frame(width: size.width-50, height: size.width-50)
                        .blendMode(.destinationOut)
                        .overlay {
                            rectangleView
                        }
                  
                }.compositingGroup()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .ignoresSafeArea()
        .onAppear {
            checkCameraPermission()
        }
        .alert(errorMessage, isPresented: $showError) {
            
        }
        .onChange(of: qrDelegate.scannerCode) { newValue in
            if let code = newValue {
                if scannerCode != code {
                    scannerCode = code
                    showSheet.toggle()
                    print(code)
                } 
            }
            
        }
        .bottomSheet(isPresented: $showSheet, height: 200) {
            EmptyView()
        }
    }
    
    func makeCameraView(size: CGSize) -> some View {
        return CameraView(frameSize: size, session: $session)
    }
    
    var rectangleView: some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .top) {
                ForEach(0...4, id: \.self) { index in
                    let rotation = Double(index)*90
                    RoundedRectangle(cornerRadius: 2, style: .circular)
                        .trim(from: 0.625 - sizeRectangle, to: 0.625 + sizeRectangle)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: rotation))
                       
                }
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 2.5)
                    .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 15)
                    .offset(y: isScanning ? size.width : 0)
                    
            }
        }.blendMode(.destinationOver)
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
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approve
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// Permission granted
                    cameraPermission = .approve
                    setupCamera()
                } else {
                    /// permission Denied
                    cameraPermission = .denied
                }
            case .denied, .restricted:
                cameraPermission = .denied
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let deveice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("Unknown error")
                return
            }
            let input = try AVCaptureDeviceInput(device: deveice)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("Unknown error")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            qrOutput.rectOfInterest = rectOfInterestConverted()
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activeScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    func rectOfInterestConverted() -> CGRect {
        let parentRect = CGRect(origin: .zero, size: cameraSize)
        let fromLayerRect = CGRect(x: 0, y: (cameraSize.height-cameraSize.width)/2, width: cameraSize.width, height: cameraSize.width)
        let parentWidth = parentRect.width
        let parentHeight = parentRect.height
        let newX = (parentWidth - fromLayerRect.maxX)/parentWidth
        let newY = 1 - (parentHeight - fromLayerRect.minY)/parentHeight
        let width = 1 - (fromLayerRect.minX/parentWidth + newX)
        let height = (fromLayerRect.maxY/parentHeight) - newY

        return CGRect(x: newX, y: newY, width: width, height: height)
    }
    
    
    func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
