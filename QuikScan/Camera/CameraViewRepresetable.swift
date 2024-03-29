//
//  CameraViewRepresetable.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    let frameSize: CGSize
    @Binding var session: AVCaptureSession
    func makeUIView(context: Context) -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let view = UIViewType(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let camera = AVCaptureVideoPreviewLayer(session: session)
        camera.frame = .init(origin: .zero, size: frameSize)
        camera.videoGravity = .resizeAspectFill
        camera.masksToBounds = true
        
        view.layer.addSublayer(camera)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

