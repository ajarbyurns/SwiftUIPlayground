//
//  Models.swift
//  SwiftUIPlayground
//
//  Created by Barry Juans on 13/03/25.
//

import Foundation

struct Character : Decodable, Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name : String
}

struct Location : Decodable, Hashable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let link: String
}

struct Music : Decodable, Hashable {
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let link: String
}
