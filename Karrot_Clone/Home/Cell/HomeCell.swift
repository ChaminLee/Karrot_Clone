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
    
    /// Home - Thumbnail Image
    let thumbnail: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        img.clipsToBounds = true
        return img
    }()
    
    /// Home - Title
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 17)
        return lb
    }()
    
    /// Home - Location
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 1
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    /// Home - Upload Time
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 2
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    /// Home - Prod Price
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        return lb
    }()
    
    /// Home - Heart
    let heartIcon: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let size: CGFloat = 19
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
    
    /// Home - Chat
    let chatIcon: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
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
    
    /// Home - Reply
    let replyIcon: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let size: CGFloat = 19
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.tintColor = UIColor(named: CustomColor.badge.rawValue)
        return bt
    }()
    
    let replyLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.badge.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 15)
        return lb
    }()

    /// Heart, Chat, Reply의 Button과 Label을 뷰로 묶어준다.
    /// StackView로 활용하기 위해
    /// View로 묶지 않고 horizontal stackview에 넣을 경우, 너비가 균등하게 되어버려 아이템들의 너비에 문제가 생긴다.
    var heartView: UIView = {
        let view = UIView()
        return view
    }()
    
    var chatView: UIView = {
        let view = UIView()
        return view
    }()
    
    var replyView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// Heart, Chat, Reply의 stackview
    var stackView = UIStackView()
    
    /// Home Cell 초기화
    /// 코드로만 구성시 인터페이스 빌더(자동 초기화)를 사용하지 않기 때문에 작성!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    /// Home Table View의 셀 재사용을 위해 변화가 예상되는 값들을 초기화
    /// = 셀의 속성을 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.isHidden = true
        
        self.chatView.isHidden = true
        self.heartView.isHidden = true
        self.replyView.isHidden = true
        
        self.heartIcon.isHidden = true
        self.heartLabel.isHidden = true
        self.chatIcon.isHidden = true
        self.chatLabel.isHidden = true
        self.replyIcon.isHidden = true
        self.replyLabel.isHidden = true
        
        self.heartIcon.imageView?.image = nil
        self.heartLabel.text = nil
        self.chatIcon.imageView?.image = nil
        self.chatLabel.text = nil
        self.replyIcon.imageView?.image = nil
        self.replyLabel.text = nil
    }
    
    /// 초기 세팅 + UI 그리기
    func config() {
        heartView.addSubview(heartIcon)
        heartView.addSubview(heartLabel)
        
        heartIcon.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        heartLabel.snp.makeConstraints {
            $0.centerY.equalTo(heartIcon.snp.centerY)
            $0.leading.equalTo(heartIcon.snp.trailing).offset(2)
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
            $0.leading.equalTo(chatIcon.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
        }
        
        replyView.addSubview(replyIcon)
        replyView.addSubview(replyLabel)
        
        replyIcon.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.height.equalTo(15)
        }
        
        replyLabel.snp.makeConstraints {
            $0.centerY.equalTo(replyIcon.snp.centerY)
            $0.leading.equalTo(replyIcon.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
        }
        
        /// StackView 초기화
        self.stackView = UIStackView(arrangedSubviews: [replyView, chatView, heartView], axis: .horizontal, spacing: 3, alignment: .center, distribution: .fill)
        stackView.isUserInteractionEnabled = false

        [thumbnail,titleLabel,locationLabel,timeLabel,priceLabel,stackView].forEach { item in
            contentView.addSubview(item)
        }
        
        thumbnail.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(18)
            $0.width.equalTo(thumbnail.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnail.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
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
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(15)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
