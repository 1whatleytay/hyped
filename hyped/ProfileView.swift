//
//  ProfileView.swift
//  hyped
//
//  Created by Yash Mulki on 2021-09-18.
//

import SwiftUI

struct ProfileView: View {
    
    let user: Person
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            Spacer()
                            VStack {
                                Image("god")
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.red, lineWidth: 5))
                                Text(user.name).font(.title).foregroundColor(.black).bold()
                                Text("\(user.score)").foregroundColor(.black)
                            }
                            Spacer()
                        }
                        
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(Color(.sRGB, red: 112/255, green: 200/255, blue: 196/255, opacity: 1.0))
                    
                    VStack {
                        
                    }
                    
                }
            }.navigationBarTitle(Text(user.name))
        }
    }
}

struct RateCell: View {
    
    let person: Person
    
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
                    Text("Rated " + person.name)
                    Text("rating goes here")
                }
                Spacer()
            }.padding(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 5))
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: Person(id: 1, name: "Yash T", score: 2))
    }
}
