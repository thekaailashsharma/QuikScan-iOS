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
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject var qrDelegate = QrScannerDelegate()
    
    @State var session: AVCaptureSession = .init()
    @State var isScanning: Bool = false
    @State private var isSafariViewPresented = false
    @State private var isSafariViewAnimation = false
    @State private var isCallingViewPresented = false
    @State private var phoneNumber: String? = nil
    @State private var isTextViewPresented = false
    @State private var email: Email? = nil
    @State private var isEmailViewPresented = false
    @State private var message: SMSMessage? = nil
    @State private var isMessageViewPresented = false
    @State private var vCard: VCard = VCard()
    @State private var isContactsViewPresented = false
    
    @State private var text: String? = nil
    
    @State private var sheetSize: PresentationDetent = .large
    @State private var qrCodeInfo: QRCodeInfo = .init(type: .none)
    @State var output: AVCaptureMetadataOutput = .init()
    @State var cameraPermissions: Permissions = .idle
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
                        Image(uiImage: generateQRCode(from: qrDelegate.scannedCode ?? "https://abc.com"))
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
                    withAnimation(.bouncy(duration: 0.9).repeatForever(autoreverses: true)) {
                        isScanning.toggle()
                    }
                })
                
            }
        }
        .popover(isPresented: Binding(
            get: { isSafariViewPresented },
            set: { newValue in
                if newValue == false {
                   resetVariables()
                }
            }), content: {
                if qrDelegate.scannedCode != nil {
                    if cameraViewModel.isValidURL(qrDelegate.scannedCode ?? "") {
                        if let url = URL(string: qrDelegate.scannedCode ?? "") {
                            SFSafariViewWrapper(url: url)
                                .presentationDetents([.large, .medium], selection: $sheetSize)
                                .ignoresSafeArea()
                        }
                    }
                }
            })
        .popover(isPresented: Binding(
            get: { isCallingViewPresented },
            set: { newValue in
                if newValue == false {
                    resetVariables()
                }
            }), content: {
                PhoneView(phoneNumber: $phoneNumber)
                    .environmentObject(cameraViewModel)
            })
        .popover(isPresented: Binding(
            get: { isTextViewPresented },
            set: { newValue in
                if newValue == false {
                    resetVariables()
                }
            }), content: {
                NonUrlView(text: $text)
            })
        .popover(isPresented: Binding(
            get: { isEmailViewPresented },
            set: { newValue in
                if newValue == false {
                    resetVariables()
                }
            }), content: {
                EmailView(emailData: $email, isEmailViewVisible: $isEmailViewPresented)
            })
        .popover(isPresented: Binding(
            get: { isMessageViewPresented },
            set: { newValue in
                if newValue == false {
                    resetVariables()
                }
            }), content: {
                MessageView(messageData: $message, isSMSViewVisible: $isMessageViewPresented)
            })
        .fullScreenCover(isPresented: Binding(
            get: { isContactsViewPresented },
            set: { newValue in
                if newValue == false {
                    resetVariables()
                }
            }), content: {
                ContactsView(vCard: $vCard, isVCardVisible: $isContactsViewPresented)
                    .environmentObject(cameraViewModel)
            })
        .onChange(of: qrDelegate.scannedCode, { oldValue, newValue in
            if qrDelegate.scannedCode != nil {
                isMessageViewPresented = false
                isEmailViewPresented = false
                withAnimation(.bouncy(duration: 0.3)) {
                    isSafariViewAnimation = true
                    cameraViewModel.qrCodeInfo = cameraViewModel.parseQRCode(qrDelegate.scannedCode ?? "OK")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.bouncy(duration: 0.3)) {
                            isSafariViewAnimation = false
                            switch cameraViewModel.qrCodeInfo.type {
                            case .text(let string):
                                text = string
                                isTextViewPresented = true
                            case .url(_):
                                isSafariViewPresented = true
                            case .vcard(let vCardValue):
                                vCard = vCardValue
                                isContactsViewPresented = true
                            case .email(let emailValue):
                                email = emailValue
                                isEmailViewPresented = true
                            case .phoneNumber(let string):
                                phoneNumber = string
                                isCallingViewPresented = true
                            case .sms(let messageValue):
                                message = messageValue
                                isMessageViewPresented = true
                            case .none:
                               break
                            }
                        }
                    }
                }
            }
            
        })
        .ignoresSafeArea()
    }
    
    func resetVariables() {
        qrDelegate.scannedCode = nil
        isSafariViewPresented = false
        isSafariViewAnimation = false
        isCallingViewPresented = false
        isTextViewPresented = false
        isEmailViewPresented = false
        isMessageViewPresented = false
        isContactsViewPresented = false
        withAnimation(.bouncy(duration: 0.9).repeatForever(autoreverses: true)) {
            isScanning.toggle()
        }
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
            DispatchQueue.global(qos: .background).async { [self] in
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
                    if session.inputs.isEmpty {
                        setupCamera()
                    } else {
                        session.startRunning()
                    }
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

#Preview {
    FullScreenCameraView()
}
