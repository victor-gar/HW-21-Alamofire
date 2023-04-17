//
//  Model.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import Foundation

// Model
struct Card: Decodable {
    let name, type, manaCost: String
    let imageUrl: String?
    let text: String?
    let power: String?
    let toughness: String?
    let rarity: String?
    
    enum CodingKeys: String, CodingKey {
        case manaCost
        case type
        case name
        case imageUrl = "imageUrl"
        case text
        case power
        case toughness
        case rarity
    }
}

struct CardListResponse: Decodable {
    let cards: [Card]
}
