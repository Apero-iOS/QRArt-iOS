//
//  ScannerView.swift
//  QRArtGenerator
//
//  Created by khac tao on 26/06/2023.
//

import SwiftUI
import AVKit

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
                                    UIView.setAnimationsEnabled(true)
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
                                Slider(value: $viewModel.zoomValue, in: 1...5) { editing in
                                    if editing {
                                        FirebaseAnalytics.logEvent(type: .scan_zoom_click)
                                    }
                                }
                                .tint(.white)
                                .onAppear {
                                    UISlider.appearance()
                                        .setThumbImage(UIImage(named: "ic_tint"), for: .normal)
                                }
                                Image(R.image.ic_zoom_out)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal)
                            Spacer()
                            
                            Color.clear.frame(height: 156+safeAreaInsets.bottom)
                                .bottomSheet(isPresented: $viewModel.showSheet, height: 156+safeAreaInsets.bottom,
                                             topBarHeight: 20,
                                             contentBackgroundColor: .clear,
                                             topBarBackgroundColor: .clear,
                                             colorOverlay: .clear,
                                             onDismiss: {
                                    qrDelegate.scannerCode = nil
                                }) {
                                    ResultQRView(result: $viewModel.qrItem, viewModel: viewModel).background(.red).cornerRadius(24, corners: [.topLeft, .topRight]).ignoresSafeArea()
                                }
                        }
                    }
                    .compositingGroup()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
            }
            .ignoresSafeArea()
            .onAppear {
                checkCameraPermission()
                FirebaseAnalytics.logEvent(type: .scan_view)
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
            }
            .onChange(of: viewModel.zoomValue) { newValue in
                viewModel.zoomCamera(value: CGFloat(newValue))
            }
            .onChange(of: viewModel.torchMode) { newValue in
                viewModel.updateTorchMode(mode: newValue)
                if newValue == .on {
                    FirebaseAnalytics.logEvent(type: .scan_flash_click)
                }
            }
            .onChange(of: qrDelegate.scannerCode) { newValue in
                viewModel.handleQRResult(text: newValue)
            }
            .sheet(isPresented: $viewModel.isShowSendMessage) {
                MessageComposeView(recipients: [viewModel.qrItem.title], body: "") { messageSent in
                    print("MessageComposeView with message sent? \(messageSent)")
                }
            }
            .sheet(isPresented: $viewModel.isShowWebView, content: {
                NavigationView{
                    WebView(urlString: viewModel.qrItem.content)
                        .ignoresSafeArea()
                        .navigationTitle(viewModel.qrItem.content)
                        .navigationBarTitleDisplayMode(.inline)
                }
            })
            .sheet(isPresented: $viewModel.isShowShareActivity, content: {
                ActivityView(url: viewModel.qrItem.content, showing: $viewModel.isShowShareActivity)
            })
            .toast(message: viewModel.toastMessage ?? "", isShowing: $viewModel.isShowToast, position: .bottom)
            
            if viewModel.showPopupAccessCamera {
                AccessPhotoPopup(onTapAction: {
                    FirebaseAnalytics.logEvent(type: .allow_access_click)
                }, onTapCancel: {
                    dismiss()
                    FirebaseAnalytics.logEvent(type: .not_allow_click)
                })
                .background(TransparentBackground())
                .padding(.all, 0)
            }
        }.onReceive(NotificationCenter.default.publisher(
            for: UIScene.willEnterForegroundNotification)) { _ in
                if viewModel.session.isRunning == false {
                    viewModel.session.startRunning()
                }
                viewModel.activeScannerAnimation()
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
                    FirebaseAnalytics.logEvent(type: .permission_view)
                    if await AVCaptureDevice.requestAccess(for: .video) {
                        /// permission granted
                        viewModel.cameraPermission = .approve
                        setupCamera()
                        FirebaseAnalytics.logEvent(type: .allow_access_click)
                    } else {
                        /// permission Denied
                        viewModel.cameraPermission = .denied
                        withAnimation {
                            viewModel.showPopupAccessCamera = true
                        }
                        FirebaseAnalytics.logEvent(type: .permission_view)
                    }
                case .denied, .restricted:
                    viewModel.cameraPermission = .denied
                    withAnimation {
                        viewModel.showPopupAccessCamera = true
                    }
                    FirebaseAnalytics.logEvent(type: .permission_view)
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
            viewModel.qrOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            viewModel.qrOutput.setSampleBufferDelegate(qrDelegate, queue: DispatchQueue(label: "my.image.handling.queue"))
            let fromLayerRect = viewModel.frameCamera
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
