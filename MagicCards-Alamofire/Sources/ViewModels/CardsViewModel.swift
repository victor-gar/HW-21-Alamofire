//
//  ViewModel.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import UIKit
import Alamofire
import AlamofireImage

// ViewModel
class CardsViewModel {
    
    private let apiURL = "https://api.magicthegathering.io/v1/cards"
    private var cards: [Card] = []
    
    var numberOfRows: Int {
        return cards.count
    }
    
    // Получение данных с API и сохранение в массив cards
    func getCards(completion: @escaping () -> ()) {
        AF.request(apiURL).validate().responseDecodable(of: CardList.self) { response in
            guard let cardsList = response.value else { return }
            self.cards = cardsList.cards
            completion()
        }
    }
    
    // Получить карту по индексу из массива cards
    func getCard(at index: Int) -> Card {
        return cards[index]
    }
}
