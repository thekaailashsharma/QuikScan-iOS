//
//  NonUrlView.swift
//  QuikScan
//
//  Created by Kailash on 30/03/24.
//

import SwiftUI

struct NonUrlView: View {
    
    @Binding var text: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let text = text {
                        Text(text)
                            .font(.customFont(.poppins, size: 20))
                            .foregroundStyle(.white)
                    }
                }
            }.navigationTitle("Your Barcode contains -")
        }
    }
}

#Preview {
    NonUrlView(text: .constant(""))
}
