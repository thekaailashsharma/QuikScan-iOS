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
    @State private var isEditOpen: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var cameraViewModel : CameraViewModel
    
    var body: some View {

        NavigationStack {
            
            if filteredItems.count == 0 {
                VStack {
                    Image("quikscan")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("Find your Barcodes here")
                        .font(.customFont(.poppins, size: 28))
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                    Text("We manage it for you")
                        .font(.customFont(.angel, size: 28))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 8)
                    
                }
            } else {
                
                List {
                    if anyPins {
                        Section {
                            ForEach(filteredItems.filter({ model in
                                model.isPinned == true
                            })) { item in
                                ItemView(item: item)
                                    .environmentObject(cameraViewModel)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            cameraViewModel.isEditOpen.toggle()
                                            cameraViewModel.currentItem = item
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.indigo)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        //                                    let model: QrModel = item
                                        Button {
                                            cameraViewModel.currentPinItem = item
                                            pinItem(model: item)
                                            //                                        }
                                        } label: {
                                            Label("Pin", systemImage: pinStatus(model: item) ? "pin.fill" : "pin.slash.fill")
                                        }
                                        .tint(.blue)
                                        
                                        Button {
                                            //                                        withAnimation {
                                            modelContext.delete(item)
                                            //                                        }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                        
                                        
                                    }
                            }
                        } header: {
                            Text("Pinned")
                        }
                    }
                    ForEach(groupedItems, id: \.0) { tuple in
                        let timeAgo = tuple.0
                        Section(header: Text(timeAgo)) {
                            ForEach(tuple.1) { item in
                                ItemView(item: item)
                                    .environmentObject(cameraViewModel)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            cameraViewModel.isEditOpen.toggle()
                                            cameraViewModel.currentItem = item
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.indigo)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        //                                    let model: QrModel = item
                                        Button {
                                            cameraViewModel.currentPinItem = item
                                            pinItem(model: item)
                                            //                                        }
                                        } label: {
                                            Label("Pin", systemImage: pinStatus(model: item) ? "pin.slash.fill" : "pin.fill")
                                        }
                                        .tint(.blue)
                                        
                                        Button {
                                            //                                        withAnimation {
                                            modelContext.delete(item)
                                            //                                        }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                        .tint(.red)
                                        
                                        
                                    }
                            }
                        }
                        
                    }
                }
                .fullScreenCover(isPresented: $cameraViewModel.isEditOpen, content: {
                    FiltersView()
                        .environmentObject(cameraViewModel)
                })
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
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Image("quikscan")
//                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
    
    func pinStatus(model: QrModel) -> Bool {
        return model.isPinned == true
    }
    
    func pinItem(model: QrModel?) {
        if let model {
            model.isPinned?.toggle()
            try? modelContext.save()
        }
    }
    
    var anyPins: Bool {
        return filteredItems.contains{$0.isPinned == true}
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
        for item in filteredItems.filter({ model in
            model.isPinned != true
        }) {
            print("Okk1 \(item.time.formatted(date: .numeric, time: .shortened))")
            let timeAgo = item.time.getTimeAgo()
            print("Okk2 \(timeAgo)")
            if result[timeAgo] == nil {
                result[timeAgo] = []
            }
            result[timeAgo]?.append(item)
        }
        return result.sortedMyModelPin(by: .orderedDescending)
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
                                        RepeatedIconView(image: "person.fill", text: mail.address.mailTrim())
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
                        default:
                            EmptyView()
                        }
                        
                    }
                    
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                
                                if image == .barMail, let mail = cameraViewModel.parseEmail(item.type) {
                                    Text(mail.address.extractDomainFromEmail() ?? "")
                                        .foregroundStyle(.primary)
                                        .font(.customFont(.poppins, size: 10))
                                } else {
                                    let _ = print("mail = Outside")
                                    Text(image.rawValue)
                                        .foregroundStyle(.primary)
                                        .font(.customFont(.poppins, size: 10))
                                }
                               
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
            if item.isEdited == true {
                imageType = Images.fromString(item.imageName ?? "")
            } else {
                imageType = cameraViewModel.getImage(for: item.type)
            }
        }
        .onChange(of: isSearching) { oldValue, newValue in
            cameraViewModel.isSearching = isSearching
        }
    }
}


struct RepeatedIconTextView : View {
    var header: String
    var text: String
    @State var data: String = ""
    @FocusState var isActive: Bool
    var body: some View {
        VStack {
            HStack {
                Text(header)
                    .font(.customFont(.poppins, size: 15))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            
            TextField(text: $data) {
                Text(header)
                    .font(.customFont(.poppins, size: 15))
                    .padding()
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
            
        }
        .onAppear {
            data = text
        }
        .padding()
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

struct FavIcon {
    enum Size: Int, CaseIterable { case s = 16, m = 32, l = 64, xl = 128, xxl = 256, xxxl = 512 }
    private let domain: String
    init(_ domain: String) { self.domain = domain }
    subscript(_ size: Size) -> String {
        "https://www.google.com/s2/favicons?sz=\(size.rawValue)&domain=\(domain)"
    }
}
