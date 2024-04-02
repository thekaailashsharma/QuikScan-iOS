//
//  FiltersView.swift
//  QuikScan
//
//  Created by Kailash on 02/04/24.
//

import SwiftUI
import SwiftData

struct FiltersView: View {
    
    @EnvironmentObject var cameraViewModel: CameraViewModel
    @Environment(\.modelContext) private var modelContext
    
    @State private var avatarScale: CGFloat = 1.0
    @State private var avatarOffset: CGFloat = 0.0
    @State private var name: String = ""
    @State private var data: String = ""
    @State private var avatarC: Images = .barCode
    @State private var avatarX: Images = .barCode
    @State private var scale: CGFloat = 0.0
    @FocusState var isNameActive: Bool
    @FocusState var isDataActive: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Choose a Tag")
                        .font(.customFont(.poppins, size: 15))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(avatarC.rawValue.capitalized)
                        .font(.customFont(.poppins, size: 15))
                        .foregroundStyle(.blue)
                }
                .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { reader in
                        HStack(alignment: .top, spacing: 16) {
                            ForEach(Images.allCases, id: \.self) { avatar in
                                
                                GeometryReader { proxy in
                                    let scale = getScale(proxy: proxy)
                                    
                                    VStack(spacing: 8) {
                                        
                                        Image(avatar.rawValue)
                                            .renderingMode(avatar == .urlGithub || avatar == .url || avatar == .medium || avatar == .twitter ? .template : .original)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                            .shadow(radius: 10)
                                            .clipped()
                                            .cornerRadius(8)
                                            .overlay(
                                                Circle()
                                                    .stroke(.white.opacity(0.4))
                                            )
                                            .shadow(radius: 3)
                                            .scaleEffect(CGSize(width: avatarScale, height: avatarScale))
                                            .offset(y: avatarOffset)
                                            .animation(.linear(duration: 1), value: avatarScale)
                                            .id(avatar.rawValue)
                                            .opacity(avatar == .dummy1 || avatar == .dummy2 ? 0 : 1)
                                        
                                            
                                    }
                                    .scaleEffect(.init(width: scale, height: scale))
                                    .animation(.easeOut(duration: 1), value: scale)
                                    .padding(.vertical)
                                    .onChange(of: scale) { oldValue, newValue in
                                        if scale > 0.95 && avatar != .dummy1 && avatar != .dummy2 {
                                            avatarC = avatar
                                        }
                                    }
                                }
                                .frame(height: 180)
                                .padding(.horizontal, 80)
//                                .padding(.vertical, 1)
                                
                            }
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation(.easeInOut(duration: 300)) {
                                                reader.scrollTo(avatarX.rawValue, anchor: .center)
                                            }
                                        }
                                    }
                            }
                        )
                    }
                }
                
                
                if let item = cameraViewModel.currentItem {
                    VStack(alignment: .listRowSeparatorLeading) {
                        
                        switch avatarX {
                        case .url:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Url Name", text: item.name)
                                RepeatedIconTextView(header: "Url Value", text: item.type)
                            }
                        case .linkedIn:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "LinkedIn Url Name", text: item.name)
                                RepeatedIconTextView(header: "LinkedIn Url Value", text: item.type)
                            }
                        case .medium:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Medium Url Name", text: item.name)
                                RepeatedIconTextView(header: "Medium Url Value", text: item.type)
                            }
                        case .twitter:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Twitter Url Name", text: item.name)
                                RepeatedIconTextView(header: "Twitter Url Value", text: item.type)
                            }
                        case .urlGithub:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Github Url Name", text: item.name)
                                RepeatedIconTextView(header: "Github Url Value", text: item.type)
                            }
                        case .urlFacebook:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Facebook Url Name", text: item.name)
                                RepeatedIconTextView(header: "Facebook Url Value", text: item.type)
                            }
                        case .urlWhatsapp:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Whatsapp Url Name", text: item.name)
                                RepeatedIconTextView(header: "Whatsapp Url Value", text: item.type)
                            }
                        case .urlInstagram:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Instagram Url Name", text: item.name)
                                RepeatedIconTextView(header: "Instagram Url Value", text: item.type)
                            }
                        case .barMail:
                            if let mail = cameraViewModel.parseEmail(item.type) {
                                VStack(alignment: .listRowSeparatorLeading) {
                                    
                                    RepeatedIconTextView(header: "Mail Address", text: mail.address)
                                    
                                    RepeatedIconTextView(header: "Mail Subject", text: mail.subject ?? "")
    
                                    RepeatedIconTextView(header: "Mail Body", text: mail.body ?? "")
                                    
                                }
                            }
                        case .barSMS:
                            if let sms = cameraViewModel.parseSMSMessage(item.type) {
                                VStack(alignment: .listRowSeparatorLeading) {

                                    RepeatedIconTextView(header: "Phone Number", text: sms.phoneNumber)
                                    
                                    RepeatedIconTextView(header: "Message", text: sms.message)
                                    
                                }
                            }
                        case .barPhone:
                            RepeatedIconView(image: "phone.fill", text: item.type.replacingOccurrences(of: "tel:", with: ""))
                        case .barvCard:
                            let vCard = cameraViewModel.parseVCard(item.type)
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Phone Number", text: vCard.phoneNumbers.first ?? "")
                                RepeatedIconTextView(header: "Phone Number", text: vCard.firstName)
                                
                            }
                            
                        case .barText:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Instagram Url Name", text: item.name)
                                RepeatedIconTextView(header: "Instagram Url Value", text: item.type)
                            }
                        case .barCode:
                            VStack(alignment: .listRowSeparatorLeading) {
                                RepeatedIconTextView(header: "Instagram Url Name", text: item.name)
                                RepeatedIconTextView(header: "Instagram Url Value", text: item.type)
                            }
                        default:
                            EmptyView()
                        }
                        
                    }
                }
                
                
                Spacer()
            }
            .navigationTitle("Edit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        cameraViewModel.isEditOpen.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }

                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                       
                    } label: {
                        Text("Save")
                            .foregroundStyle(.blue)
                    }

                }
            }
        }
        .onAppear {
            if let item = cameraViewModel.currentItem {
                name = item.name
                data = item.type
                avatarX = cameraViewModel.getImage(for: item.type)
            }
        }
        
    }
    
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 125
        
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 125
        
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        
        return scale
    }
}

struct CurvedShape: Shape {
    var offset: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + max(offset, 0)))
        path.addArc(withCenter: CGPoint(x: rect.maxX / 2, y: rect.minY + max(offset, 0)), radius: rect.width / 2, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.minY + max(offset, 0)))
        path.close()
        return Path(path.cgPath)
    }
}


//#Preview {
//    FiltersView()
//}
