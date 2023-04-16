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
    private let urlString = "https://api.magicthegathering.io/v1/cards"
    private let cache = NSCache<NSString, AnyObject>()


    func fetchCards(completion: @escaping () -> Void) {
            if let cachedData = cache.object(forKey: "cards" as NSString) as? CardListResponse {
                // данные уже есть в кэше, загружаем их оттуда
                self.cards = cachedData.cards
                completion()
                return
            }
            
            // данные не были найдены в кэше, загружаем их с сервера
            AF.request(urlString)
                .validate()
                .responseDecodable(of: CardListResponse.self) { response in
                    switch response.result {
                    case .success(let cardListResponse):
                        self.cards = cardListResponse.cards
                        // сохраняем данные в кэш
                        self.cache.setObject(cardListResponse as AnyObject, forKey: "cards" as NSString)
                    case .failure(let error):
                        print("Error fetching cards: \(error.localizedDescription)")
                    }
                    completion()
                }
        }
    
    func numberOfCards() -> Int {
        return cards.count
    }
    
    func card(at index: Int) -> Card {
        return cards[index]
    }
    
    func search(for searchText: String, completion: @escaping () -> Void) {
        if searchText.isEmpty {
            completion()
        } else {
            let parameters: [String: Any] = [
                "name": searchText,
                "pageSize": 50,
                "unique": true
            ]
            
            AF.request(urlString, parameters: parameters)
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
