//
//  MagicCardTableViewCell.swift
//  MagicCards-Alamofire
//
//  Created by Victor Garitskyu on 13.04.2023.
//

import SnapKit
import AlamofireImage
import UIKit

class MagicCardTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let cardImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cardImageView)
    }
    
    private func setupLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(cardImageView.snp.leading).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        cardImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(80)
        }
    }
    
    func configure(with viewModel: CardViewModel) {
           nameLabel.text = viewModel.name
           if let imageUrl = viewModel.imageUrl {
               cardImageView.af.setImage(withURL: imageUrl)
           }
       }
}
