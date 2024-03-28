//
//  LoginView.swift
//  QuikScan
//
//  Created by Kailash on 28/03/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var phoneNumber: String = ""
    @State var countryCode: String = "IN"
    @State var smsCode: String = ""
    @State var isOTPVisible: Bool = false
    @State var isLoading: Bool = false
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            Group {
                VStack {
                    VStack {
                        ForEach(1...5, id: \.self) { _ in
                            HStack(spacing: 20) {
                                ForEach(1...min(iconsList.count, Int(UIScreen.main.bounds.width / 100)) + 1 , id: \.self) { _ in
                                    let icon = iconsList[Int.random(in: 0..<3)]
                                    LoginCard(icon: icon)
                                        .frame(width: 120)
                                        .padding(.all, 4)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(icon.color)
                                        }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                    .opacity(0.6)
                    Spacer()
                }
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(LinearGradient(colors: [.black, .black.opacity(0.6), .black.opacity(0.4)], startPoint: .bottom, endPoint: .top))
                        .frame(height: UIScreen.main.bounds.height / 1.4)
                }
                VStack {
                    Spacer()
                    VStack {
                        Image("quikscan")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text("Your Favourite Barcodes")
                            .font(.customFont(.poppins, size: 28))
                            .foregroundStyle(.white)
                            .padding(.bottom, 8)
                        Text("Were never so Seamless")
                            .font(.customFont(.angel, size: 30))
                            .kerning(2.0)
                            .foregroundStyle(.white)
                    }.offset(y: 60)
                    
                    Spacer()
                    ZStack {
                        VStack {
                            EnterPhoneNumber(number: $phoneNumber, countryCode: $countryCode, smsCode: $smsCode, isOTPVisble: $isOTPVisible) {
                                isLoading = true
                                if !isOTPVisible {
                                    authManager.startAuth(phoneNumber: "+\(getCountryCode(countryCode))\(phoneNumber)") { value in
                                        isLoading = false
                                        if value {
                                            withAnimation(.spring.delay(1)) {
                                                isOTPVisible.toggle()
                                            }
                                        }
                                    }
                                } else {
                                    authManager.verifyCode(smsCode: smsCode) { value in
                                        if value {
                                            print("Hurray")
                                        }
                                    }
                                }
                                
                            }
                        }
                        .rotation3DEffect(.degrees(isOTPVisible ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                        .scaleEffect(x: !isOTPVisible ? -1 : 1, y: 1)
                        .animation(.spring, value: isOTPVisible)
                        
                        
                        
                    }
                    .offset(y: -50)
                    
                    
                    
                }
            }
            .blur(radius: isLoading ? 10: 0)
            
            if isLoading {
                ProgressView {
                    Text("You will be redirected !!")
                        .font(.customFont(.poppins, size: 35))
                        .foregroundStyle(.white)
                }
                .animation(.bouncy, value: isLoading)
            }
            
            
        }.ignoresSafeArea()
    }
}

struct EnterPhoneNumber: View {
    @Binding var number: String
    @Binding var countryCode: String
    @Binding var smsCode: String
    @Binding var isOTPVisble: Bool
    @FocusState var isNumberActive: Bool
    @FocusState var isOTPActive: Bool
    var onClick: () -> Void
    let darkBlue = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    var body: some View {
        VStack {
            if !isOTPVisble {
                HStack {
                    Picker(selection: $countryCode) {
                        ForEach(countryDictionary.sorted(by: <), id: \.key) { key , value in
                            HStack {
                                Text("\(countryName(countryCode: key) ?? key)").tag(value)
                            }
                            
                        }
                    } label: {
                        Text("+\(countryCode)")
                    }
                    
                    
                    
                    TextField(text: $number, label: {
                        Text("Enter Phone Number")
                            .font(.customFont(.poppins, size: 15))
                            .padding()
                    })
                    .keyboardType(.decimalPad)
                    .submitLabel(.continue)
                    .focused($isNumberActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isNumberActive = false
                                onClick()
                            }
                        }
                    }
                    .font(.customFont(.poppins, size: 18))
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5))
                    }
                }
                .padding()
            }
            else {
                HStack {
                    TextField(text: $smsCode, label: {
                        Text("Enter OTP Here.")
                            .font(.customFont(.poppins, size: 15))
                            .padding()
                    })
                    .keyboardType(.decimalPad)
                    .submitLabel(.go)
                    .focused($isOTPActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                isOTPActive = false
                                onClick()
                            }
                        }
                    }
                    .font(.customFont(.poppins, size: 18))
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5))
                    }
                }
            }
            Spacer()
            Button(action: {
                onClick()
            }, label: {
                Text(isOTPVisble ? "Take Me In" : "Proceed Ahead")
                    .font(.customFont(.poppins, size: 20))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: 300)
                    .background(Color(uiColor: .black).opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.5))
                    }
                
            })
            Spacer()
            HStack {
                Circle()
                    .fill(isOTPVisble ? .white.opacity(0.6): .white)
                    .frame(width: 10, height: 10)
                
                Circle()
                    .fill(!isOTPVisble ? .white.opacity(0.6): .white)
                    .frame(width: 10, height: 10)
                
            }
        }
        .frame(width: 350, height: 300, alignment: .top)
        
    }
}

struct LoginCard: View {
    var icon: MarqueeIcon
    var body: some View {
        HStack(spacing: 8) {
            Image(icon.icon)
                .resizable()
                .frame(width: 50, height: 50)
            Text(icon.name)
                .foregroundStyle(.primary.opacity(0.8))
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.trailing, 4)
        }
    }
}

#Preview {
    LoginView()
}
