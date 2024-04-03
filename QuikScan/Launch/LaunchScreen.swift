//
//  LaunchScreen.swift
//  QuikScan
//
//  Created by Kailash on 04/04/24.
//

import SwiftUI

struct LaunchScreen: View {
    @Binding var scale: CGFloat
    @Binding var isVisible: Bool
    @State var opacity = 1.0
    
    var body: some View {
        VStack {
            Image("quikscan")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(scale)
                .padding()
            VStack(spacing: 8) {
                Text("Your Favourite Barcodes")
                    .font(.customFont(.poppins, size: 24))
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)
                Text("Were never so Seamless")
                    .font(.customFont(.angel, size: 24))
                    .kerning(2.0)
                    .foregroundStyle(.white)
            }
            
        }
        .opacity(opacity)
        .onAppear {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 0.15)) {
                    opacity = 0.0
                    scale = 6.0
                    isVisible = false
                }
            }
            
        }
    }
}


