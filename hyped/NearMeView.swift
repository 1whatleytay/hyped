//
//  NearMeView.swift
//  hyped
//
//  Created by Yash Mulki on 2021-09-18.
//

import SwiftUI

struct NearMeView: View {
    
    @State var nearMePeople: [ProfileData] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(nearMePeople, id: \.self) { person in
                        NavigationLink(
                            destination: ProfileView(user: person),
                            label: {
                                NearMePersonCell(person: person).padding(EdgeInsets.init(top: 7, leading: 5, bottom: 7, trailing: 5)).background(Color(.sRGB, red: 25/255, green: 25/255, blue: 25/255, opacity: 1.0)).cornerRadius(15)                            })
                    }
                }
            }.navigationBarTitle(Text("Near Me"))
        }.onAppear(perform: {
            // Fetch people and put it into near me people
            nearMePeople = [ProfileData(imgLink: nil, name: "Vineeth Monke", score: 0.0), ProfileData(imgLink: nil, name: "Nagabhusahn", score: 99.0)]
        })
    }
}

struct NearMePersonCell: View {
    
    let person: ProfileData
    
    var body: some View {
        NavigationLink(destination: ProfileView(user: person), label: {
            HStack(spacing: 10) {
                Image("god")
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
        NearMeView()
    }
}
