//
//  PhoneView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI

struct PhoneView: View {
    @Binding var phoneNumber: String?
    @EnvironmentObject var cameraViewModel: CameraViewModel
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "phone.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue)
                .padding()
            Text("Placing Call")
                .font(.customFont(.poppins, size: 30))
                .foregroundStyle(.white)
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let number = phoneNumber {
                    cameraViewModel.placeCall(number: number)
                }
            }
        }
        .padding()
    }
}

#Preview {
    PhoneView(phoneNumber: .constant("123"))
}
