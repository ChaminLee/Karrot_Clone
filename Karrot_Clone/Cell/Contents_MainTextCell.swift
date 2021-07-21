//
//  Contents_MainText.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit

protocol ContentsMainTextDelegate: AnyObject {
    func categoryButtonTapped()
}

class Contents_MainTextCell: UITableViewCell {
    
    // 사이클을 방지하기 위해
    var cellDelegate: ContentsMainTextDelegate?
    
    static let identifier = "Contents_MainTextCell"
    
    var interestCount = 10

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
        lb.text = "라미 라인 프렌즈 한정판 에디션 만년필 세트22 팔아요옹 (브라운)"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 18)
        return lb
    }()
    
    let categoryButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("기타 중고물품", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        bt.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
        return bt
    }()
    
    @objc func categoryClicked() {
        print("카테고리다아")
        cellDelegate?.categoryButtonTapped()
    }
    
    let timeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "∙ 17분 전"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let mainLabel: UILabel = {
        let lb = UILabel()
        lb.text = """
        전자제품(특히 게임/컴퓨터쪽) 온/오프매장에서는 중고를 개인에게서 매입해 되팔기도 하지만, 판매 때 싼 가격책정이나 직접 살 때보다 조금은 더 비싼 가격 때문에 매물부터가 잘 없는 마당이라 보통 '중고거래'라 하면 각종 사이트나 카페에 있는 중고장터에서 이루어지는 것을 말한다
        """
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        
        let attrStr = NSMutableAttributedString(string: lb.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrStr.length))
        lb.attributedText = attrStr
        
        lb.font = UIFont(name: "Helvetica", size: 14)
        return lb
    }()
    
    var stackView = UIStackView()
    
    let chatLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "관심 10"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let heartLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "관심 10"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let visitedLabel: UILabel = {
        let lb = UILabel()
//        lb.text = "∙ 조회 17"
        lb.textColor = UIColor(named: CustomColor.reply.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.isHidden = true
        
        self.chatLabel.isHidden = true
        self.heartLabel.isHidden = true
        self.visitedLabel.isHidden = true
        
    }
    
    func config() {
        
        self.stackView = UIStackView.init(arrangedSubviews: [chatLabel,heartLabel,visitedLabel])
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
        
//        heartLabel.snp.makeConstraints {
//            $0.top.equalTo(mainLabel.snp.bottom).offset(15)
//            $0.leading.equalTo(mainLabel.snp.leading)
//        }
//
//        visitedLabel.snp.makeConstraints {
//            $0.top.equalTo(heartLabel.snp.top)
//            $0.leading.equalTo(heartLabel.snp.trailing).offset(5)
//            $0.bottom.equalToSuperview().inset(40)
//        }
    }
}
