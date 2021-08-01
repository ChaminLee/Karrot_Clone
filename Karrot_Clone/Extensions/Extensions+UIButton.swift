//
//  Extensions+UIButton.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/08/01.
//

import Foundation
import UIKit

extension UIButton {
    func addBottomLine(font: UIFont, color: UIColor, string: String) -> NSMutableAttributedString {
        let attr: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: color,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let attrStr = NSMutableAttributedString(string: string ,attributes: attr)
        
        return attrStr
    }
}
