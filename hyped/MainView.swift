//
//  MainView.swift
//  hyped
//
//  Created by Yash Mulki on 2021-09-18.
//

import SwiftUI

struct MainView: View {
    
    @State var view = 1
    
    var body: some View {
        TabView(selection: $view) {
            ProfileView(user: ProfileData(imgLink: nil, name: "My profile", score: 6.0))
                .tabItem { Label("Me", systemImage: "person.circle.fill") }.tag(0)
            NearMeView()
                .tabItem { Label("Near Me", systemImage: "dot.radiowaves.left.and.right") }.tag(1)
            LocalLeaderboardView()
                .tabItem { Label("Rankings", systemImage: "list.star") }.tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
