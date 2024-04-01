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
    
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    
    var body: some View {

        NavigationStack {
            List {
                ForEach(groupedItems, id: \.0) { tuple in
                    let timeAgo = tuple.0
                    Section(header: Text(timeAgo)) {
                        ForEach(tuple.1) { item in
                            ItemView(item: item)
                                .environmentObject(cameraViewModel)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .searchable(text: $cameraViewModel.searchText, prompt: "Search Your Barcodes")
            .overlay(content: {
                if cameraViewModel.isSearching && !cameraViewModel.searchText.isEmpty && filteredItems.count == 0 {
                    ContentUnavailableView.search
                }
            })
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
    
    var filteredItems: [QrModel] {
        if cameraViewModel.searchText.isEmpty {
            return items
        }
        let filters = items.compactMap { item in
            let value = item.contains(cameraViewModel.searchText)
            return value ? item : nil
        }
        return filters
    }
    
    var groupedItems: [(String, [QrModel])] {
        var result: [String: [QrModel]] = [:]
        print("Okk \(filteredItems.debugDescription)")
        for item in filteredItems.sorted(by: { lhs, rhs in
            lhs.time > rhs.time
        }) {
            print("Okk1 \(item.time.formatted(date: .numeric, time: .shortened))")
            let timeAgo = item.time.getTimeAgo()
            print("Okk2 \(timeAgo)")
            if result[timeAgo] == nil {
                result[timeAgo] = []
            }
            result[timeAgo]?.append(item)
        }
        return result.sortedMyModel(by: .orderedDescending)
    }
}


struct ItemView: View {
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    @Environment(\.isSearching) private var isSearching
    
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
                        .renderingMode(image == .urlGithub || image == .url || image == .medium || image == .twitter ? .template : .original)
                        .resizable()
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(width: 50, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 4)
                    
                    VStack(alignment: .listRowSeparatorLeading) {
                        
                        switch image {
                        case .url:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .linkedIn:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .medium:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .twitter:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlGithub:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlFacebook:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 15))
                        case .urlWhatsapp:
                            Text(item.name.urlTrim().truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .urlInstagram:
                            Text(item.name.urlTrim().truncate(length: 18))            
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .barMail:
                            if let mail = cameraViewModel.parseEmail(item.type) {
                                VStack(alignment: .listRowSeparatorLeading) {
                                    if mail.address != "" {
                                        RepeatedIconView(image: "person.fill", text: mail.address)
                                    }
                                    if mail.subject != "" {
                                        RepeatedIconView(image: "mail.fill", text: mail.subject?.truncate(length: 18) ?? "")
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
                                        RepeatedIconView(image: "message.fill", text: sms.message.truncate(length: 18))
                                    }
                                }
                            }
                        case .barPhone:
                            RepeatedIconView(image: "phone.fill", text: item.type.replacingOccurrences(of: "tel:", with: ""))
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
                            Text(item.name.truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        case .barCode:
                            Text(item.name.truncate(length: 18))
                                .foregroundStyle(.white)
                                .font(.customFont(.poppins, size: 13))
                        }
                        
                    }
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Text(image.rawValue)
                                    .foregroundStyle(.primary)
                                    .font(.customFont(.poppins, size: 10))
                            }
                            .buttonStyle(BorderedProminentButtonStyle())
                        }
                    }
                }
            }
        }
        .frame(height: 70)
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            imageType = cameraViewModel.getImage(for: item.type)
        }
        .onChange(of: isSearching) { oldValue, newValue in
            cameraViewModel.isSearching = isSearching
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
                .font(.customFont(.poppins, size: 11))
        }
    }
}
