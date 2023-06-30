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
    @Environment(\.dismiss) var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
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
                        VStack(spacing: 0) {
                            Spacer().frame(height: safeAreaInsets.top)
                            
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(R.image.ic_close)
                                        .foregroundColor(.white)
                                }.frame(width: 40, height: 40)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Spacer().frame(height: size.width/5)
                            GeometryReader { geometry in
                                let frame = geometry.frame(in: CoordinateSpace.global)
                                Rectangle()
                                    .frame(width: heightRectangle, height: heightRectangle)
                                    .blendMode(.destinationOut)
                                    .overlay {
                                        rectangleView
                                    }.onAppear {
                                        viewModel.frameCamera = frame
                                    }
                            }.frame(width: heightRectangle, height: heightRectangle)
                            
                            // Flash
                            Button {
                                viewModel.tourchClick()
                            } label: {
                                Image(viewModel.torchMode == .on ? R.image.ic_flash_on : R.image.ic_flash_off)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 48, height: 48)
                            .background(.white.opacity(0.3))
                            .cornerRadius(30)
                            .padding(.vertical, 24)
                            
                            // Zoom
                            HStack(spacing: 16) {
                                Image(R.image.ic_zoom_in)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                Slider(value: $viewModel.zoomValue, in: 1...5) { editing in }
                                    .tint(.white)
                                Image(R.image.ic_zoom_out)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            
                        }
                    }
                    .compositingGroup()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
            }
            .ignoresSafeArea()
            .onAppear {
                checkCameraPermission()
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
            }
            .onChange(of: viewModel.zoomValue) { newValue in
                viewModel.zoomCamera(value: CGFloat(newValue))
            }
            .onChange(of: viewModel.torchMode) { newValue in
                viewModel.updateTorchMode(mode: newValue)
            }
            .onChange(of: qrDelegate.scannerCode) { newValue in
                viewModel.handleQRResult(text: newValue)
            }
            .bottomSheet(isPresented: $viewModel.showSheet, height: 200,
                         contentBackgroundColor: .clear,
                         topBarBackgroundColor: Color.clear,
                         onDismiss: {
                qrDelegate.scannerCode = nil
            }) {
                ResultQRView(result: $viewModel.qrItem)
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
            guard let deveice = viewModel.deveice else {
                viewModel.presentError("Unknown error")
                return
            }
            if viewModel.zoomValue <= deveice.maxAvailableVideoZoomFactor {
                try deveice.lockForConfiguration()
                deveice.videoZoomFactor = viewModel.zoomValue
                deveice.unlockForConfiguration()
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
            let fromLayerRect = viewModel.frameCamera
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