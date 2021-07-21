//
//  HomeCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import Foundation
import UIKit
import SnapKit

class HomeCell: UITableViewCell {

    static let identifier = "HomeCell"
    
    let thumbnail: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "당근이")
        img.contentMode = .scaleAspectFill
            
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 17)
        return lb
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 1
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        return lb
    }()
    
    let heartIcon: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let size: CGFloat = 18
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.tintColor = UIColor(named: CustomColor.badge.rawValue)
        bt.imageView?.contentMode = .scaleAspectFit
        return bt
    }()
    
    let heartLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.badge.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 15)
        return lb
    }()
    
    let chatIcon: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 38, height: 30)
        let size: CGFloat = 23
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.tintColor = UIColor(named: CustomColor.badge.rawValue)
        return bt
    }()
    
    let chatLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.badge.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 15)
        return lb
    }()

    var heartView: UIView = {
        let view = UIView()
        return view
    }()
    
    var chatView: UIView = {
        let view = UIView()
        return view
    }()
    
    var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.isHidden = true
        
        self.chatView.isHidden = true
        self.heartView.isHidden = true
        
        self.heartLabel.isHidden = true
        self.heartIcon.isHidden = true
        self.chatIcon.isHidden = true
        self.chatLabel.isHidden = true
    }
    
    func config() {
        heartView.addSubview(heartIcon)
        heartView.addSubview(heartLabel)
        
        heartIcon.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        heartLabel.snp.makeConstraints {
            $0.centerY.equalTo(heartIcon.snp.centerY)
            $0.leading.equalTo(heartIcon.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
        }
        
        chatView.addSubview(chatIcon)
        chatView.addSubview(chatLabel)
        
        chatIcon.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        chatLabel.snp.makeConstraints {
            $0.centerY.equalTo(chatIcon.snp.centerY)
            $0.leading.equalTo(chatIcon.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
        }
        
        self.stackView = UIStackView.init(arrangedSubviews: [chatView,heartView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        
        [thumbnail,titleLabel,locationLabel,timeLabel,priceLabel,stackView].forEach { item in
            contentView.addSubview(item)
        }
        
        thumbnail.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(15)
            $0.width.equalTo(thumbnail.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(thumbnail.snp.top)
        }
        
        locationLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(locationLabel.snp.trailing).offset(3)
            $0.top.equalTo(locationLabel.snp.top)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(locationLabel.snp.bottom).offset(10)
        }
        
        stackView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension HomeCell {
    func stackViewConfig(_ stackview: UIStackView) {
        stackview.distribution = .fill
        stackview.axis = .horizontal
        stackview.alignment = .center
    }
    
}
