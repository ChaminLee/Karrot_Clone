//
//  ContentsCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit

class ContentsCell: UITableViewCell {

    static let identifier = "ContentsCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    func config() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
