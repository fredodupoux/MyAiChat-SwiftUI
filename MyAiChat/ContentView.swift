//
//  ContentView.swift
//  MyAiChat
//
//  Created by Frederic Dupoux on 6/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
