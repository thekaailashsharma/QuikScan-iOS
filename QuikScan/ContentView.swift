//
//  ContentView.swift
//  QuikScan
//
//  Created by Kailash on 27/03/24.
//

import SwiftUI
import AVKit



struct ContentView: View {
    @State var session: AVCaptureSession = .init()
    @StateObject var authManager = AuthManager()
    @StateObject var cameraViewModel : CameraViewModel = CameraViewModel()
    @State var tabSelection: Tabs = .home
    @State var scale: CGFloat = 1.0
    @State var launchVisible: Bool = true
    var body: some View {
        if launchVisible {
            LaunchScreen(scale: $scale, isVisible: $launchVisible)
        } else {
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
                                .onTapGesture {
                                    session.stopRunning()
                                }
                        }
                        .tag(Tabs.home)
                    
                    FullScreenCameraView(session: $session)
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
                                .onTapGesture {
                                    session.stopRunning()
                                }
                            
                        }
                        .tag(Tabs.create)
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .onChange(of: tabSelection, { old, new in
                if tabSelection != .camera {
                    session.stopRunning()
                }
            })
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
}

enum Tabs {
    case home, camera, create
}

#Preview {
    ContentView()
}
