//
//  LocationItemCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit

extension UITableViewCell {
    func configure(with optionItem: LocationOptionItem) {
        textLabel?.text = optionItem.text
        textLabel?.font = optionItem.font
        // 클릭 시 텍스트 bold 처리로 변경 
        accessoryType = optionItem.isSelected ? .checkmark : .none
    }
    
    func configManner(with optionItem: MannerDetailnfo) {
        textLabel?.text = optionItem.label.text
        textLabel?.font = optionItem.font
    }
}
