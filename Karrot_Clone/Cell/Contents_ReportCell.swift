//
//  ContentsCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import Foundation
import UIKit
import SnapKit

class Contents_ReportCell: UITableViewCell {

    static let identifier = "Contents_ReportCell"
    
    // Input과 return이 없다는 의미
    // Closure optional로 만들기 위해 ()로 덮었씌움
    var reportButtonAction : (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
        self.reportButton.addTarget(self, action: #selector(reportClicked), for: .touchUpInside)
    }
    
    let reportButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("이 게시글 신고하기", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.text.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
        return bt
    }()
    
    @objc func reportClicked() {
        print("신고해!!")
        reportButtonAction?()
    }
    
    func config() {
        contentView.addSubview(reportButton)
        
        reportButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
