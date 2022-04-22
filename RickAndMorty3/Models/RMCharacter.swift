//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Felix Alexander Sotelo Quezada on 30-03-21.
//

import Foundation

struct Character: Codable, Hashable {
    let id      : Int
    let name    : String
    let status  : String
    let species : String
    let gender  : String
    let image   : String
}
