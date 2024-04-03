//
//  ContentView.swift
//  QuikScan
//
//  Created by Kailash on 27/03/24.
//

import SwiftUI



struct ContentView: View {
    @StateObject var authManager = AuthManager()
    @StateObject var cameraViewModel : CameraViewModel = CameraViewModel()
    @State var tabSelection: Tabs = .home
    var body: some View {
//        NavigationStack {
            TabView(selection: $tabSelection) {
                Group {
                    HomeView()
                        .environmentObject(cameraViewModel)
                            .tabItem {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.primary)
                            }
                            .tag(Tabs.home)

                        FullScreenCameraView()
                        .environmentObject(cameraViewModel)
                            .tabItem {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.primary)
                            }
                            .tag(Tabs.camera)
                    
                    ViewQr(qrCodeValue: "")
                        .tabItem {
                            Image(systemName: "macwindow.badge.plus")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.white)
                            
                        }
                        .tag(Tabs.create)
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .navigationTitle(tabSelection == .create ? "Create" : "QuikScan")
            .toolbar(tabSelection == .camera ? .hidden : .automatic, for: .automatic)
            .tint(.black)
            .onAppear {
                authManager.getLoginStatus()
            }
            .onChange(of: authManager.isLoggedIn, { oldValue, newValue in
                print("Values = \(oldValue) \(newValue)")
                authManager.getLoginStatus()
            })
            .fullScreenCover(isPresented: $authManager.isLoggedIn, content: {
                LoginView()
                    .environmentObject(authManager)
            })
//        }
        .ignoresSafeArea()
    }
}

enum Tabs {
    case home, camera, create
}

#Preview {
    ContentView()
}
