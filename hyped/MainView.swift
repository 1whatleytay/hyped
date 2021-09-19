//
//  MainView.swift
//  hyped
//
//  Created by Yash Mulki on 2021-09-18.
//

import SwiftUI

struct MainView: View {
    var interface: Interface?
    
    let defaultPerson = Person(id: 2, name: "My profile", score: 4, picture: nil)
    
    @State var people = [InterfacePair]()
    
    @State var view = 1
    
    var body: some View {
        TabView(selection: $view) {
            ProfileView(user: interface?.user ?? defaultPerson)
                .tabItem { Label("Me", systemImage: "person.circle.fill") }.tag(0)
            NearMeView(nearMePeople: $people)
                .tabItem { Label("Near Me", systemImage: "dot.radiowaves.left.and.right") }.tag(1)
            LocalLeaderboardView()
                .tabItem { Label("Rankings", systemImage: "list.star") }.tag(2)
        }.onAppear(perform: {
            interface?.begin(binding: self.$people)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
