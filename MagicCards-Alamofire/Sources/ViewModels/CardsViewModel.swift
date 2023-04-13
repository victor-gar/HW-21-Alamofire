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
    private var filteredCards: [Card] = []
    private var isFiltering: Bool = false

    var numberOfRows: Int {
        return isFiltering ? filteredCards.count : cards.count
    }

    // Получение данных с API и сохранение в массив cards
    func getCards(completion: @escaping () -> ()) {
        AF.request(apiURL).validate().responseDecodable(of: CardList.self) { response in
            guard let cardsList = response.value else { return }
            self.cards = cardsList.cards
            completion()
        }
    }
 
    func getCard(at index: Int) -> Card {
        return isFiltering ? filteredCards[index] : cards[index]
    }

    // Фильтрация карт по названию
    func filterCards(with searchText: String) {
        filteredCards = cards.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        isFiltering = true
    }

    // Отмена фильтрации карт
    func cancelFilter() {
        isFiltering = false
    }

}
