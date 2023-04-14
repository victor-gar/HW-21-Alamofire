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

    private let nameLabelS = UILabel()
    private let imageViewS = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(nameLabelS)
        contentView.addSubview(imageViewS)
    }
    
    private func setupLayout() {
        nameLabelS.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(imageViewS.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        imageViewS.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(80)
        }
    }
    
    func configure(with card: Card) {
        // Отображение информации о карте
        nameLabelS.text = card.name
        if let imageUrl = card.imageUrl {
            AF.request(imageUrl).response { response in
                if let data = response.data {
                    self.imageViewS.image = UIImage(data: data)
                }
            }
        } else {
            self.imageViewS.image = nil
        }
    }
}
