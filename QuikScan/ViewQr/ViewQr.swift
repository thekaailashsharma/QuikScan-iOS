//
//  ViewQr.swift
//  QuikScan
//
//  Created by Kailash on 03/04/24.
//

import SwiftUI
import QRCode

struct ViewQr: View {
    var qrCodeValue: String
    @State var qrCodeStyles: QrCodeStyles = .colored
    @State var data: String = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @FocusState var isActive: Bool
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    if !isActive {
                        Button(action: {
                            withAnimation {
                                switch qrCodeStyles {
                                case .flateye:
                                    qrCodeStyles = .panda
                                case .panda:
                                    qrCodeStyles = .colored
                                case .colored:
                                    qrCodeStyles = .flateye
                                }
                            }
                        }, label: {
                            Text(qrCodeStyles.rawValue.capitalized)
                                .font(.customFont(.poppins, size: 20))
                                .foregroundStyle(.white)
                        })
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding()
                        
                        Spacer()
                    }
                    
                    QRCodeDocumentUIView(document: getDoc(style: qrCodeStyles))
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 300)
                        .padding()
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
                    
                    if !isActive {
                        Spacer()
                    }
                    
                    TextField(text: $data) {
                        Text("Your QrCode Data")
                            .font(.customFont(.poppins, size: 15))
                            .padding()
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .submitLabel(.continue)
                    .font(.customFont(.poppins, size: 18))
                    .focused($isActive)
                    .onSubmit {
                        withAnimation {
                            isActive.toggle()
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5))
                    }
                    .padding()
                    
                }
            }
            .onAppear {
                data = qrCodeValue
            }
//        }.tint(.blue)
    }
    
    func getDoc(style: QrCodeStyles) -> QRCode.Document {
        
        switch qrCodeStyles {
        case .flateye:
            return doc1()
        case .panda:
            return doc2()
        case .colored:
            return doc3()
        }
        
    }
    
    
    func doc2() -> QRCode.Document {
        let doc = QRCode.Document(utf8String: data)
        
        doc.design.style.background = QRCode.FillStyle.Image(CGImage.named("panda"))
        
        doc.design.style.eyeBackground = CGColor(srgbRed: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        
        doc.design.shape.onPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
        doc.design.style.onPixels = QRCode.FillStyle.Solid(215 / 255, 224 / 255, 219 / 255)
        
        doc.design.shape.offPixels = QRCode.PixelShape.Star(insetFraction: 0.4)
//        doc.design.style.offPixels = QRCode.FillStyle.Solid(0, 0, 0)
        
        doc.design.shape.eye = QRCode.EyeShape.Leaf()
        doc.design.shape.pupil = QRCode.PupilShape.BarsHorizontal()
        
        let svg = doc.svg(dimension: 300)
        
        return doc
    }
    
    func doc3() -> QRCode.Document {
        // Part 3
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        doc.design.backgroundColor(CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1.00))
        doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel(cornerRadiusFraction: 0.8)
        doc.design.style.onPixels = QRCode.FillStyle.Solid(1.000, 0.733, 0.424, alpha: 1.000)

        doc.design.style.eye   = QRCode.FillStyle.Solid(0.831, 0.537, 0.416, alpha: 1.000)
        doc.design.style.pupil = QRCode.FillStyle.Solid(0.624, 0.424, 0.400, alpha: 1.000)

        doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()

        if let image = CGImage.image(named: "quikscan") {
            
            // Centered square logo
            doc.logoTemplate = QRCode.LogoTemplate(
                image: image,
                path: CGPath(rect: CGRect(x: 0.35, y: 0.35, width: 0.30, height: 0.30), transform: nil),
                inset: 2
            )
        }

        let logoQRCode = doc.platformImage(dimension: 300, dpi: 144)
        let pdfData = doc.pdfData(dimension: 300)!

        let imageData = doc.pngData(dimension: 400)
        return doc
    }
    
    func doc1() ->QRCode.Document {
            
        let doc = QRCode.Document(utf8String: data, errorCorrection: .high)
        
            doc.design.backgroundColor(CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1.00))
            doc.design.shape.eye = QRCode.EyeShape.Squircle()
            doc.design.style.eye = QRCode.FillStyle.Solid(108.0 / 255.0, 76.0 / 255.0, 191.0 / 255.0)
            doc.design.style.pupil = QRCode.FillStyle.Solid(168.0 / 255.0, 33.0 / 255.0, 107.0 / 255.0)
            
            doc.design.style.onPixels = QRCode.FillStyle.Solid(215 / 255, 224 / 255, 219 / 255)
            doc.design.shape.onPixels = QRCode.PixelShape.Squircle(insetFraction: 0.1)
            
            if let image = CGImage.image(named: "quikscan") {
                // Create a logo 'template'
                doc.logoTemplate = QRCode.LogoTemplate(
                    image: image,
                    path: CGPath(rect: CGRect(x: 0.49, y: 0.4, width: 0.45, height: 0.22), transform: nil),
                    inset: 4
                )
            }
        
        return doc
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
}


extension CGImage {
    static func image(named name: String) -> CGImage? {
        guard let image = UIImage(named: name) else {
            return nil
        }
        return image.cgImage
    }
}

enum QrCodeStyles: String {
    case flateye = "Flat-Eye", panda = "Panda", colored = "Colored"
}

//#Preview {
//    ViewQr()
//}
