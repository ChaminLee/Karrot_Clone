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
        lb.text = "당근 타이틀"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 17)
        return lb
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.text = "위치"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 1
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.text = " ・ 4분 전"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "10,000원"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        return lb
    }()
    
    let heartIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "heart")
        img.tintColor = UIColor(named: CustomColor.badge.rawValue)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let heartLabel: UILabel = {
        let lb = UILabel()
        lb.text = "2351"
        lb.textColor = UIColor(named: CustomColor.badge.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let chatIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "bubble,left.and.bubble.right")
        img.tintColor = UIColor(named: CustomColor.badge.rawValue)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let chatLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.badge.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    func config() {
        
        [thumbnail,titleLabel,locationLabel,timeLabel,priceLabel,heartIcon,heartLabel,chatIcon,chatLabel].forEach { item in
            contentView.addSubview(item)
        }
        
        thumbnail.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(15)
            $0.width.equalTo(thumbnail.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(30)
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
        
        heartLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(15)
            
        }
        
        heartIcon.snp.makeConstraints {
            $0.trailing.equalTo(heartLabel.snp.leading)
            $0.centerY.equalTo(heartLabel.snp.centerY)
            $0.width.height.equalTo(17)
        }
        
        chatLabel.snp.makeConstraints {
            $0.trailing.equalTo((heartIcon.snp.leading))
            $0.centerY.equalTo(heartLabel.snp.centerY)
        }
        
        chatIcon.snp.makeConstraints {
            $0.trailing.equalTo(chatLabel.snp.leading).offset(-5)
            $0.centerY.equalTo(chatLabel.snp.centerY)
            $0.width.height.equalTo(17)
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
