//
//  CardViewModel.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import Foundation
import Alamofire

class CardListViewModel {
    
    private var cards = [Card]()
    
    func fetchCards(completion: @escaping () -> Void) {
        // Получение данных с API
        AF.request("https://api.magicthegathering.io/v1/cards")
            .validate()
            .responseDecodable(of: CardListResponse.self) { response in
                switch response.result {
                case .success(let cardListResponse):
                    self.cards = cardListResponse.cards
                case .failure(let error):
                    print("Error fetching cards: \(error.localizedDescription)")
                }
                completion() // добавлен аргумент
            }
    }
    
    func numberOfCards() -> Int {
        return cards.count
    }
    
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    func search(for searchText: String, completion: @escaping () -> Void) {
        // Фильтрация данных по поисковому запросу
        if searchText.isEmpty {
            // Если поисковый запрос пустой, то отображаем все карты
            completion()
        } else {
            AF.request("https://api.magicthegathering.io/v1/cards?name=\(searchText)")
                .validate()
                .responseDecodable(of: CardListResponse.self) { response in
                    switch response.result {
                    case .success(let cardListResponse):
                        self.cards = cardListResponse.cards
                    case .failure(let error):
                        print("Error fetching cards: \(error.localizedDescription)")
                    }
                    completion()
                }
        }
    }
}
