//
//  ContentView.swift
//  SwiftUIPlayground
//
//  Created by Barry Juans on 13/03/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            FirstTab()
                .tabItem {
                    Label("Characters", systemImage: "house")
                }
            SecondTab()
                .tabItem {
                    Label("Locations", systemImage: "music.note")
                }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .lightGray
        }
    }
}

struct FirstTab: View {
    
    @State private var searchText = ""
    @State private var shownCharacters: [Character] = []
    @State private var defaultCharacters: [Character] = []
    
    struct SearchView: View {
        @Binding var searchText: String
        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.blue)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
                TextField("Search Character", text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
            .background(Color.gray)
        }
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    SearchView(searchText: $searchText)
                        .onChange(of: searchText, initial: false) { _, new  in
                            filter(input: new)
                        }
                    ForEach(shownCharacters, id: \.id) { character in
                        NavigationLink(value: character) {
                            Text(character.name)
                                .foregroundStyle(Color.black)
                                .frame(width: abs(geometry.size.width - 20), height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(.black, lineWidth: 4)
                                )
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        }
                    }
                    .background(Color.white)
                    .listStyle(.plain)
                }
                .navigationDestination(for: Character.self) { character in
                    Text(character.name)
                        .navigationBarHidden(false)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .background(Color.white)
        .onAppear {
            getData()
        }
    }
    
    private func getData(){
        defaultCharacters = [
            Character(id: 0, name: "Arthur"),
            Character(id: 1, name: "Barry"),
            Character(id: 2, name: "Casey"),
            Character(id: 3, name: "Diana"),
            Character(id: 4, name: "Elon"),
            Character(id: 5, name: "Fanta"),
            Character(id: 6, name: "Golem"),
            Character(id: 7, name: "Hugh"),
            Character(id: 8, name: "Iman"),
            Character(id: 9, name: "Joe"),
            Character(id: 10, name: "Kurt"),
            Character(id: 11, name: "Leon"),
            Character(id: 12, name: "Meryl"),
            Character(id: 13, name: "Naamah"),
            Character(id: 14, name: "Orange"),
        ]
        shownCharacters = defaultCharacters
    }
    
    private func filter(input: String) {
        guard !input.isEmpty else {
            shownCharacters = defaultCharacters
            return
        }
        let temp = defaultCharacters.filter {
            $0.name.lowercased().contains(input.lowercased())
        }
        shownCharacters = temp
    }
}

struct SecondTab: View {
    var body: some View {
        VStack{}
    }
}
