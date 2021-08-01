//
//  MannerDeatailnfo.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import Foundation
import UIKit

protocol MannerItem {
    var label: UILabel { get set }
    var font: UIFont { get set }
}

extension MannerItem {
    func sizeForManneerText() -> CGSize {
        return label.text!.size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
