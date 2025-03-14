//
//  Models.swift
//  SwiftUIPlayground
//
//  Created by Barry Juans on 13/03/25.
//

import Foundation

enum Status : String, Decodable {
    case Alive, Dead, unknown
}

enum Gender : String, Decodable {
    case Male, Female, Genderless, unknown
}

struct Character : Decodable, Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name : String
}

struct CharacterLocation : Decodable, Hashable {
    let name : String
    let url : String?
}

struct CharacterPageInfo : Decodable {
    let count : Int
    let pages : Int
    let next : String?
    let prev : String?
}

struct CharactersResponse : Decodable {
    let error: String?
    let info: CharacterPageInfo?
    let results : [Character]?
}
