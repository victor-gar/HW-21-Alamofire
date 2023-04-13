//
//  Model.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import Foundation

// Model
struct Card: Codable {
    let name: String
    let imageUrl: String
    let text: String
}

struct CardList: Codable {
    let cards: [Card]
}
