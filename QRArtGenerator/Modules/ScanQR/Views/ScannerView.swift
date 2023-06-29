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
    
    @StateObject var qrDelegate = QRScannerDelegate()
    @StateObject var viewModel = ScannerViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader {
                let size = $0.size
                let heightRectangle = size.width - viewModel.paddinRectangle*2
                
                ZStack(alignment: .center) {
                    CameraView(frameSize: size, cameraLayer: viewModel.cameraLayer, session: $viewModel.session)
                    
                    // Mask
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.5))
                            .ignoresSafeArea()
                        Rectangle()
                            .frame(width: heightRectangle, height: heightRectangle)
                            .blendMode(.destinationOut)
                    }.compositingGroup()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    rectangleView.frame(width: heightRectangle, height: heightRectangle)
                    
                }.onAppear {
                    viewModel.cameraSize = size
                }
            }
            .ignoresSafeArea()
            .onAppear {
                checkCameraPermission()
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
                
            }
            
            VStack(spacing: 10) {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.backward.circle")
                            .foregroundColor(.white)
                    }.frame(width: 40, height: 40)
                    Spacer()
                }
                
                Spacer()
                Button {
                    viewModel.tourchClick()
                } label: {
                    Image(systemName: "flashlight.off.fill").foregroundColor(.white)
                }
                .frame(width: 48, height: 48)
                .background(.white.opacity(0.3))
                .cornerRadius(30)
                
                // Zoom
                HStack(spacing: 8) {
                    Image(systemName: "minus.magnifyingglass")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    Slider(value: $viewModel.zoomValue, in: 1...5) { editing in }
                        .tint(.white)
                    Image(systemName: "plus.magnifyingglass")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            .onChange(of: viewModel.zoomValue) { newValue in
                viewModel.zoomCamera(value: CGFloat(newValue))
            }
            .onChange(of: viewModel.torchMode) { newValue in
                viewModel.updateTorchMode(mode: newValue)
            }
            .onChange(of: qrDelegate.scannerCode) { newValue in
                viewModel.handleQRResult(text: newValue)
            }
            .bottomSheet(isPresented: $viewModel.showSheet, height: 200, onDismiss: {
                qrDelegate.scannerCode = nil
            }) {
                EmptyView()
            }
        }
    }
    
    var rectangleView: some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .top) {
                ForEach(0...4, id: \.self) { index in
                    let rotation = Double(index)*90
                    RoundedRectangle(cornerRadius: 1.5, style: .circular)
                        .trim(from: 0.625 - viewModel.sizeRectangle, to: 0.625 + viewModel.sizeRectangle)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: rotation))
                    
                }
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 2.5)
                    .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 15)
                    .offset(y: viewModel.isScanning ? size.width : 0)
                
            }
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                viewModel.cameraPermission = .approve
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    /// permission granted
                    viewModel.cameraPermission = .approve
                    setupCamera()
                } else {
                    /// permission Denied
                    viewModel.cameraPermission = .denied
                }
            case .denied, .restricted:
                viewModel.cameraPermission = .denied
            default: break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let deveice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                viewModel.presentError("Unknown error")
                return
            }
            let input = try AVCaptureDeviceInput(device: deveice)
            
            guard viewModel.session.canAddInput(input), viewModel.session.canAddOutput(viewModel.qrOutput) else {
                viewModel.presentError("Unknown error")
                return
            }
            viewModel.session.beginConfiguration()
            viewModel.session.addInput(input)
            viewModel.session.addOutput(viewModel.qrOutput)
            viewModel.qrOutput.metadataObjectTypes = [.qr]
            let fromLayerRect = CGRect(x: 0, y: (viewModel.cameraSize.height-viewModel.cameraSize.width)/2, width: viewModel.cameraSize.width, height: viewModel.cameraSize.width)
            viewModel.qrOutput.rectOfInterest = viewModel.cameraLayer.metadataOutputRectConverted(fromLayerRect: fromLayerRect)
            viewModel.qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            viewModel.session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                viewModel.session.startRunning()
            }
            viewModel.activeScannerAnimation()
        } catch {
            viewModel.presentError(error.localizedDescription)
        }
    }
    
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
