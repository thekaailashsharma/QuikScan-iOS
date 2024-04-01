//
//  ContentView.swift
//  QuikScan
//
//  Created by Kailash on 27/03/24.
//

import SwiftUI



struct ContentView: View {
    @StateObject var authManager = AuthManager()
    @State var tabSelection: Tabs = .home
    var body: some View {
        NavigationStack {
            TabView(selection: $tabSelection) {
                Group {
//                    NavigationStack {
                        HomeView()
                            .tabItem {
                                Label("Tab 1", systemImage: tabSelection == .home ? "house.fill" : "house")
                                
                                   
                               
                            }
                            .tag(Tabs.home)
//                    }
                    
//                    NavigationStack {
                        Text("Maps")
                            .tabItem {
                                Image(systemName: tabSelection == .home ? "location.north" : "location.north.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.white)
                                
                            }
                            .tag(Tabs.maps)
//                    }
                    
//                    NavigationStack {
                        FullScreenCameraView()
                            .tabItem {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.primary)
                            }
                            .tag(Tabs.camera)
//                    }
                }
                
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
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
        }
        .ignoresSafeArea()
    }
}

enum Tabs {
    case home, camera, maps
}

#Preview {
    ContentView()
}
