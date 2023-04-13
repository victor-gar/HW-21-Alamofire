//
//  CardViewModel.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import Foundation

class CardViewModel {
    
    private let card: Card
    
    var name: String {
        return card.name
    }
    
    var imageUrl: URL? {
        return URL(string: card.imageUrl)
    }
    
    var text: String {
        return card.text
    }
    
    init(card: Card) {
        self.card = card
    }
}
