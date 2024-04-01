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
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedItems.keys.sorted(by: >), id: \.self) { timeAgo in
                    Section(header: Text(timeAgo)) {
                        ForEach(groupedItems[timeAgo] ?? []) { item in
                            ItemView(item: item)
                                .environmentObject(cameraViewModel)
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.black.opacity(0.85))
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    var groupedItems: [String: [QrModel]] {
        var result: [String: [QrModel]] = [:]
        for item in items {
            let timeAgo = item.time.timeAgo()
            if result[timeAgo] == nil {
                result[timeAgo] = []
            }
            result[timeAgo]?.append(item)
        }
        return result
    }
}


struct ItemView: View {
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    let item: QrModel
    var onClick: () -> Void = {}
    @State var imageType: Images? = .barCode
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(alignment: .center) {
                if let image = imageType {
                    Image(image.rawValue)
                        .renderingMode(image == .urlGithub || image == .urlNone ? .template : .original)
                        .resizable()
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(width: 50, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 4)
                    
                    VStack(alignment: .listRowSeparatorLeading) {
                        
                        Text(image.rawValue)
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.customFont(.poppins, size: 10))
                        
                        switch image {
                        case .urlNone:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlLinkedIn:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlMedium:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlTwitter:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlGithub:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlFacebook:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 15))
                        case .urlWhatsapp:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlInstagram:
                            Text(item.name)
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .barMail:
                            if let mail = cameraViewModel.parseEmail(item.type) {
                                VStack(alignment: .listRowSeparatorLeading) {
                                    if mail.address != "" {
                                        RepeatedIconView(image: "person.fill", text: mail.address)
                                    }
                                    if mail.subject != "" {
                                        RepeatedIconView(image: "mail.fill", text: mail.subject?.truncate(length: 20) ?? "")
                                    }
                                }
                            }
                        case .barSMS:
                            if let sms = cameraViewModel.parseSMSMessage(item.type) {
                                VStack(alignment: .listRowSeparatorLeading) {
                                    if sms.phoneNumber != "" {
                                        RepeatedIconView(image: "phone.fill", text: sms.phoneNumber)
                                    }
                                    if sms.message != "" {
                                        RepeatedIconView(image: "message.fill", text: sms.message.truncate(length: 20))
                                    }
                                }
                            }
                        case .barPhone:
                            RepeatedIconView(image: "phone.fill", text: item.type)
                        case .barvCard:
                            let vCard = cameraViewModel.parseVCard(item.type)
                            VStack(alignment: .listRowSeparatorLeading) {
                                if vCard.firstName != "" {
                                    RepeatedIconView(image: "person.fill", text: vCard.firstName)
                                }
                                if vCard.phoneNumbers.count > 0 {
                                    RepeatedIconView(image: "phone.fill", text: vCard.phoneNumbers.first ?? "")
                                }
                            }
                            
                        case .barText:
                            Text(item.name.truncate(length: 20))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .barCode:
                            Text(item.name.truncate(length: 20))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .frame(height: 70)
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            imageType = cameraViewModel.getImage(for: item.type)
        }
    }
}


struct RepeatedIconView : View {
    var image: String
    var text: String
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: image)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 20, height: 15)
            
            Text(text)
                .lineLimit(1)
                .foregroundStyle(.white.opacity(0.8))
                .font(.customFont(.poppins, size: 10))
        }
    }
}
