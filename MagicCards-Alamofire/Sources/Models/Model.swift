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
    
    enum CodingKeys: String, CodingKey {
        case manaCost
        case type
        case name
        case imageUrl = "imageUrl"
    }
}

struct CardListResponse: Decodable {
    let cards: [Card]
}
