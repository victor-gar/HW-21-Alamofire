//
//  MagicCardTableViewCell.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import SnapKit
import AlamofireImage
import Alamofire
import UIKit

class MagicCardTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MagicCardTableViewCell"
    
    // MARK: - UI Elements
    
    private let viewBack: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10 // добавляем закругление
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.white
        return label
    }()
    
    private let labelMana: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        label.textColor = UIColor.white
        return label
    }()
    
    private let labelManaText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor.white
        return label
    }()
    
    private let imageViewUrl: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let cardInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let viewBackType: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .clear
        return view
    }()
    
    //MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        layoutGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Setups
    
    
    private func setupHierarchy() {
        contentView.addSubview(viewBackType)
        contentView.addSubview(viewBack)
        contentView.addSubview(cardInfoStackView)
        contentView.addSubview(imageViewUrl)
        cardInfoStackView.addArrangedSubview(nameLabel)
        cardInfoStackView.addArrangedSubview(labelMana)
        cardInfoStackView.addArrangedSubview(labelManaText)
        
        
        backgroundColor = .clear
        selectionStyle = .none
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.gray.cgColor
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    private func setupLayout() {
        viewBack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        imageViewUrl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalTo(85)
        }
        
        cardInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(imageViewUrl.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        labelMana.snp.makeConstraints { make in
            make.leading.equalTo(imageViewUrl.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(5)
        }
        
        labelManaText.snp.makeConstraints { make in
            make.bottom.equalTo(labelMana.snp.top).offset(5)
        }
        
        viewBackType.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
    }
    
    private  func layoutGradient() {
        viewBack.layer.cornerRadius = 10
        viewBack.layer.masksToBounds = true
        
        let gradientColors = [
            UIColor(red: 0.65, green: 0.54, blue: 0.94, alpha: 0.5).cgColor,
            UIColor(red: 0.79, green: 0.58, blue: 0.93, alpha: 0.5).cgColor,
            UIColor(red: 0.87, green: 0.62, blue: 0.87, alpha: 0.5).cgColor,
            UIColor(red: 0.94, green: 0.69, blue: 0.72, alpha: 0.5).cgColor,
            UIColor(red: 0.99, green: 0.81, blue: 0.57, alpha: 0.5).cgColor
        ]
        
        let randomColorIndex = Int(arc4random_uniform(UInt32(gradientColors.count)))
        let gradientColor = gradientColors[randomColorIndex]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientColor, UIColor.black.cgColor]
        gradientLayer.locations = [1.5, 1.0]
        gradientLayer.frame = viewBack.bounds
        viewBack.layer.insertSublayer(gradientLayer, at: 0)
        
        viewBackType.layer.cornerRadius = 5
        viewBackType.layer.masksToBounds = true
        viewBackType.layer.shadowOpacity = 0.1
        viewBackType.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewBackType.layer.shadowRadius = 5
        viewBackType.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func configure(with card: Card) {
        
        self.imageViewUrl.image = nil
        self.nameLabel.text = nil
        self.labelMana.text = nil
        self.labelManaText.text = nil
        
        if let imageUrl = card.imageUrl, let url = URL(string: imageUrl) {
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageViewUrl.image = UIImage(data: data)
                        self.nameLabel.text = card.name
                        self.labelMana.text = card.type
                        self.labelManaText.text = card.type
                        self.layoutGradient()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageViewUrl.image = nil
                        self.nameLabel.text = card.name
                        self.labelMana.text = card.type
                        self.labelManaText.text = card.type
                        self.layoutGradient()
                    }
                }
            }
        } else {
            self.imageViewUrl.image = UIImage(named: "image")
            self.nameLabel.text = card.name
            self.labelMana.text = card.type
            self.labelManaText.text = card.type
            self.layoutGradient()
            
        }
        viewBackType.backgroundColor = card.type == "Instant" ? .black : .systemOrange
    }
}
