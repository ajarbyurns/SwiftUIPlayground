//
//  ContentView.swift
//  SwiftUIPlayground
//
//  Created by Barry Juans on 13/03/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    var body: some View {
        TabView {
            FirstTab()
                .tabItem {
                    Label("Texts", systemImage: "text.bubble")
                }
            SecondTab()
                .tabItem {
                    Label("Images", systemImage: "photo")
                }
            ThirdTab()
                .tabItem {
                    Label("Music", systemImage: "music.note")
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
                    ScrollView(.vertical) {
                        ForEach(shownCharacters, id: \.id) { character in
                            NavigationLink(value: character) {
                                Text(character.name)
                                    .foregroundStyle(Color.black)
                                    .frame(width: abs(geometry.size.width - 20), height: 50)
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
    
    @State var locations: [Location] = []
    
    struct ImageGridItem: View {
        var link: String = ""
        var body: some View {
            AsyncImage(url: URL(string: link)) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(let error):
                        if (error as? URLError)?.code == .cancelled {
                            ImageGridItem(link: link)
                        } else {
                            Text("Image Loading Error")
                        }
                    default:
                        Image(systemName: "photo")
                }
            }
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))], spacing: 10) {
                ForEach(locations, id: \.id) { loc in
                    ImageGridItem(link: loc.link)
                }
            }
            .padding(20)
        }
        .onAppear {
            getData()
        }
    }
    
    private func getData() {
        var temp = [Location]()
        for id in 0...25 {
            temp.append(Location(id: id, link: "https://picsum.photos/200"))
        }
        locations = temp
    }
}

struct ThirdTab: View {
    
    @State private var songs: [Music] = []
    @State private var playSongId: Int? = nil
    @StateObject private var soundManager = SoundManager()
    
    class SoundManager : ObservableObject {
        var audioPlayer: AVPlayer?

        func playSound(sound: String){
            if let url = URL(string: sound) {
                self.audioPlayer = AVPlayer(url: url)
            }
        }
    }
    
    struct MusicGridItem: View {
        var song: Music
        @Binding var playSongId: Int?
        @EnvironmentObject var soundManager: SoundManager
        
        var body: some View {
            VStack {
                Image(systemName: song.id == playSongId ? "pause.circle.fill": "play.circle.fill")
                    .font(.system(size: 25))
                    .onTapGesture {
                        if playSongId == song.id {
                            playSongId = nil
                            soundManager.audioPlayer?.pause()
                        } else {
                            playSongId = song.id
                            soundManager.playSound(sound: song.link)
                            soundManager.audioPlayer?.play()
                        }
                    }
            }
            .frame(width: 150, height: 150)
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))], spacing: 10) {
                ForEach(songs, id: \.id) { song in
                    MusicGridItem(song: song, playSongId: $playSongId)
                }
            }
            .padding(20)
        }
        .environmentObject(soundManager)
        .onAppear {
            getData()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
                soundManager.audioPlayer?.seek(to: .zero)
                soundManager.audioPlayer?.play()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    private func getData() {
        songs = [
            Music(id: 1, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 2, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 3, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 4, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 5, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 6, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 7, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 8, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 9, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 10, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 11, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 12, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 13, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 14, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 15, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 16, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 17, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 18, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
            Music(id: 19, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2670_fma-164754_001_00-03-37.mp3"),
            Music(id: 20, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/2671_fma-164755_001_00-00-02.mp3"),
            Music(id: 21, link: "https://citizen-dj.labs.loc.gov/audio/samplepacks/loc-fma/A-Good-Start_fma-182157_001_00-00-02.mp3"),
        ]
    }
}
