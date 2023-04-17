//
//  MagicDetailViewController.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 17.04.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class MagicDetailViewController: UIViewController {
    // MARK: - Properties
    
    public var card: Card?
    
    // MARK: - UI Elements
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let cardPowerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.systemRed
        label.numberOfLines = 0
        return label
    }()
    
    private let cardManaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.systemGreen
        label.numberOfLines = 0
        return label
    }()
    
    private let cardTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let cardRarityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let cardTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        configure()
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        view.addSubview(cardImageView)
        view.addSubview(cardNameLabel)
        view.addSubview(cardTextLabel)
        view.addSubview(cardManaLabel)
        view.addSubview(cardTypeLabel)
        view.addSubview(cardPowerLabel)
        view.addSubview(cardRarityLabel)
    }
    
    private func setupLayout() {
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.3)
            make.height.equalTo(cardImageView.snp.width)
        }
        
        cardNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(-5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardManaLabel.snp.makeConstraints { make in
            make.top.equalTo(cardNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(cardManaLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardPowerLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTypeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardRarityLabel.snp.makeConstraints { make in
            make.top.equalTo(cardPowerLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardTextLabel.snp.makeConstraints { make in
            make.top.equalTo(cardRarityLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
    }
    
    // MARK: - Actions
    
    func configure() {
        if let card = card {
            self.cardImageView.image = nil
            self.cardNameLabel.text = nil
            self.cardTextLabel.text = nil
            self.cardManaLabel.text = nil
            self.cardTypeLabel.text = nil
            self.cardPowerLabel.text = nil
            self.cardRarityLabel.text = nil
            if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.cardImageView.image = UIImage(data: data)
                            self.cardNameLabel.text = card.name
                            self.cardTextLabel.text = card.text
                            self.cardManaLabel.text = "ManaCost: \(card.manaCost)"
                            self.cardTypeLabel.text = "Type: \(card.type)"
                            self.cardPowerLabel.text = "Power: \(card.power ?? "")"
                            self.cardRarityLabel.text = "Rarity: \(card.rarity ?? "")"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.cardImageView.image = UIImage(named: "image")
                            self.cardNameLabel.text = "Name: -"
                            self.cardTextLabel.text = "Text: -"
                            self.cardManaLabel.text = "ManaCost: -"
                            self.cardTypeLabel.text = "Type: -"
                            self.cardPowerLabel.text = "Power: -"
                            self.cardRarityLabel.text = "Rarity: -"
                        }
                    }
                }
            }
        }
    }
}
