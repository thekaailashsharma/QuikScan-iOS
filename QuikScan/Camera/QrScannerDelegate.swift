//
//  QrScannerDelegate.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI
import AVKit

class QrScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    static let delegate = QrScannerDelegate()
    
    @Published var scannedCode: String?
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let Code = readableObject.stringValue else { return }
            scannedCode = Code
        }
    }
}


