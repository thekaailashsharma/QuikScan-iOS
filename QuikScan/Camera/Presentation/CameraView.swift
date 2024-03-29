//
//  CameraView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import AVKit
import CoreImage.CIFilterBuiltins

struct FullScreenCameraView: View {
    @State var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var output: AVCaptureMetadataOutput = .init()
    @State private var cameraPermissions: Permissions = .idle
    @StateObject private var qrDelegate = QrScannerDelegate()
    @State private var isSafariViewPresented = false
    @State private var isSafariViewAnimation = false
    @State private var sheetSize: PresentationDetent = .large
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            
            CameraView(frameSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), session: $session)
            
            GeometryReader { proxy in
                let size = proxy.size
                ZStack {
                    
                    ForEach(1...4, id: \.self) { index in
                        let rotation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .trim(from: 0.60, to: 0.65)
                            .stroke(.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(rotation))
                            .padding(.all, 65)
                            .scaleEffect(isSafariViewAnimation ? 0.9 : isScanning ? 1.1: 0.9)
                            .opacity(!isSafariViewAnimation ? 1 : 0)
                            .animation(.bouncy, value: isSafariViewAnimation)
                    }
                    .overlay {
                        Image(uiImage: generateQRCode(from: "https://abc.com"))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                ForEach(1...4, id: \.self) { index in
                                    let rotation = Double(index) * 90
                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                        .trim(from: 0.60, to: 0.65)
                                        .stroke(.black.opacity(0.8), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                        .rotationEffect(.degrees(rotation))
                                }
                            }
                            .opacity(isSafariViewAnimation ? 1 : 0)
                            .animation(.bouncy, value: isSafariViewAnimation)
                        
                        
                    }
                }
                .frame(width: size.width, height: size.width, alignment: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: {
                    checkCameraPermission()
                    withAnimation(.bouncy(duration: 1.6).repeatForever(autoreverses: true)) {
                        isScanning.toggle()
                    }
                })
                
            }
        }
        .popover(isPresented: Binding(
            get: { isSafariViewPresented && qrDelegate.scannedCode != nil },
            set: { newValue in
                if newValue == false {
                    qrDelegate.scannedCode = nil
                    isSafariViewPresented = newValue
                    isSafariViewAnimation = false
                }
            }), content: {
                if isValidURL(qrDelegate.scannedCode ?? "") {
                    if let url = URL(string: qrDelegate.scannedCode ?? "") {
                        SFSafariViewWrapper(url: url)
                            .presentationDetents([.large, .medium], selection: $sheetSize)
                            .ignoresSafeArea()
                    }
                } else {
                    Text(qrDelegate.scannedCode ?? "OK")
                        .foregroundStyle(.black)
                }
            })
        .onChange(of: qrDelegate.scannedCode, { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.6)) {
                isSafariViewAnimation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isSafariViewAnimation = false
                        
                        isSafariViewPresented = true
                    }
                    
                    
                }
            }
            
        })
        .ignoresSafeArea()
    }
    
    func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string),
              let scheme = url.scheme?.lowercased() else {
            print("Error creating URL")
            return false
        }
        
        // Check if the scheme is HTTP or HTTPS
        return scheme == "http" || scheme == "https"
    }
    
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back).devices.first else {
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(output)
            output.metadataObjectTypes = [.aztec, .catBody, .code128, .code39, .code39Mod43, .code93, .dataMatrix, .dogBody, .ean13, .ean8, .interleaved2of5, .pdf417, .qr, .salientObject, .upce]
            output.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            
        } catch  {
            print("Errorr is \(error.localizedDescription)")
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermissions = .approved
                    setupCamera()
                } else {
                    cameraPermissions = .denied
                }
            case .restricted:
                cameraPermissions = .denied
            case .denied:
                cameraPermissions = .denied
            case .authorized:
                cameraPermissions = .approved
                setupCamera()
            @unknown default:
                break
            }
        }
    }
}


enum Permissions: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}

#Preview {
    FullScreenCameraView()
}
