//
//  ContentsCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit

class Contents_ReportCell: UITableViewCell {

    static let identifier = "Contents_ReportCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    let idLabel: UILabel = {
        let lb = UILabel()
        lb.text = "이 게시글 신고하기"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 13)
        return lb
    }()
    
    func config() {
        contentView.addSubview(idLabel)
        
        idLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
