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
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let cardDescriptionLabel: UILabel = {
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
        view.addSubview(cardDescriptionLabel)
    }
    
    private func setupLayout() {
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.3)
            make.height.equalTo(cardImageView.snp.width)
        }
        
        cardNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        cardDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(cardNameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    // MARK: - Actions
    
    func configure() {
        // Отображение информации о карте
        
        if let card = card {
            self.cardImageView.image = nil
            self.cardNameLabel.text = nil
            self.cardDescriptionLabel.text = nil
            
            
            if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.cardImageView.image = UIImage(data: data)
                            self.cardNameLabel.text = card.name
                            self.cardDescriptionLabel.text = card.type
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Если изображение не удалось загрузить, показываем пустые значения
                            self.cardImageView.image = UIImage(named: "image")
                            self.cardNameLabel.text = card.name
                            self.cardDescriptionLabel.text = card.type
                        }
                    }
                }
                
            }
        } else {
            // Если ссылки на изображение нет, показываем пустые значения
            self.cardImageView.image = UIImage(named: "image")
            self.cardNameLabel.text = card?.name
            self.cardDescriptionLabel.text = card?.type
            
            
            
            
        }
    }
    
}
