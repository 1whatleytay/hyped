//
//  NearMeView.swift
//  hyped
//
//  Created by Yash Mulki on 2021-09-18.
//

import SwiftUI

struct NearMeView: View {
    @Binding var nearMePeople: [InterfacePair]
    
    let interface: Interface?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(nearMePeople, id: \.self) { pair in
                        NavigationLink(
                            destination: ProfileView(user: pair.person),
                            label: {
                                NearMePersonCell(person: pair.person, interface: interface)
                                    .padding(.init(top: 7, leading: 5, bottom: 7, trailing: 5))
                                    .background(
                                        Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0))
                                    .cornerRadius(15)
                            }
                        )
                    }
                }
            }.navigationBarTitle(Text("Near Me"))
        }
    }
}

struct NearMePersonCell: View {
    let person: Person
    
    let interface: Interface?
    
    var body: some View {
        NavigationLink(destination: RateCell(person: person, interface: interface), label: {
            HStack(spacing: 10) {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 5))
                VStack(alignment: .leading, spacing: 5) {
                    Text(person.name)
                    Text("\(person.score)")
                }
                Spacer()
            }.padding(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 5))
        })
    }
}

struct NearMeView_Previews: PreviewProvider {
    static var previews: some View {
        NearMeView(nearMePeople: .constant([
            .init(instance: nil, person: Person(id: 4, name: "Vineeth Monke", score: 5, picture: nil)),
            .init(instance: nil, person: Person(id: 5, name: "Nagabhusahn", score: 0, picture: nil))
        ]), interface: nil)
    }
}
