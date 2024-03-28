//
//  ContentView.swift
//  QuikScan
//
//  Created by Kailash on 27/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button {
                    authManager.signOut()
                } label: {
                    Text("Sign Out")
                }

            }
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
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
