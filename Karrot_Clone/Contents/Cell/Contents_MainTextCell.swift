//
//  Contents_MainText.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit

/// 프로토콜 선언
/// 카테고리 버튼 클릭시 페이지 이동을 위함
protocol ContentsMainTextDelegate: AnyObject {
    func categoryButtonTapped()
}

class Contents_MainTextCell: UITableViewCell {
    
    /// delegate
    var cellDelegate: ContentsMainTextDelegate?
    
    static let identifier = "Contents_MainTextCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
        self.categoryButton.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.lineBreakStrategy = .hangulWordPriority
        lb.font = UIFont(name: "Helvetica-Bold", size: 18)
        return lb
    }()
    
    let categoryButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        bt.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
        return bt
    }()
    
    @objc func categoryClicked() {
        cellDelegate?.categoryButtonTapped()
    }
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let mainLabel: UILabel = {
        let lb = UILabel()
        /// 줄간
        lb.text = "."
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        
        /// 줄간격
        let attrStr = NSMutableAttributedString(string: lb.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.lineBreakStrategy = .hangulWordPriority
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrStr.length))
        lb.attributedText = attrStr
        
        lb.font = UIFont(name: "Helvetica", size: 14)
        
        return lb
    }()
    
    var stackView = UIStackView()
    
    let chatLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let heartLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let visitedLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    var chatView: UIView = {
        let view = UIView()
        return view
    }()
    
    var heartView: UIView = {
        let view = UIView()
        return view
    }()
    
    var visitView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.isHidden = true
        
        self.chatView.isHidden = true
        self.heartView.isHidden = true
        self.visitView.isHidden = true
        
        self.chatLabel.isHidden = true
        self.heartLabel.isHidden = true
        self.visitedLabel.isHidden = true
        
    }
    
    func config() {
        heartView.addSubview(heartLabel)
        
        heartLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        chatView.addSubview(chatLabel)
        
        chatLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        visitView.addSubview(visitedLabel)
        
        visitedLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        self.stackView = UIStackView.init(arrangedSubviews: [chatView,heartView,visitView])
        stackView.spacing = 3
        stackView.distribution = .fill
        
        [titleLabel, categoryButton, timeLabel, mainLabel, stackView].forEach { item in
            contentView.addSubview(item)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        categoryButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryButton.snp.trailing).offset(5)
            $0.centerY.equalTo(categoryButton.snp.centerY)
        }
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(categoryButton.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(mainLabel.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().inset(40)
        }
        
    }
}
