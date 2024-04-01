//
//  HomeView.swift
//  QuikScan
//
//  Created by Kailash on 01/04/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var items: [QrModel]
    
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            //            if isDummyDataSavedOnce {
            List {
                ForEach(items) { item in
                    ItemView(item: item)
                        .environmentObject(homeViewModel)
                }
            }
        }
    }
}


struct ItemView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    let item: QrModel
    @State var imageType: Images? = .barCode
    var body: some View {
        HStack {
            if let image = imageType {
                Image(image.rawValue)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                
                VStack {
                    
                    Text("Type: Url.")
                        .foregroundStyle(.white)
                        .font(.customFont(.poppins, size: 16))
                    
                    Text(item.name)
                        .foregroundStyle(.white)
                        .font(.customFont(.poppins, size: 16))
                }
            }
        }
        .onAppear {
            if let url = item.url {
                imageType = homeViewModel.getImageType(for: url)
            }
        }
    }
}

#Preview {
    HomeView()
}
