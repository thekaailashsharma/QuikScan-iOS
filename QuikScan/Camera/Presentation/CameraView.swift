//
//  CameraView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import AVKit

struct FullScreenCameraView: View {
    @State var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var output: AVCaptureMetadataOutput = .init()
    @State private var cameraPermissions: Permissions = .idle
    @State private var qrDelegate = QrScannerDelegate()
    
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
                            .scaleEffect(isScanning ? 1.1: 0.9)
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
        .ignoresSafeArea()
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
