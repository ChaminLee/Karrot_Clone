//
//  LocationOption.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import Foundation
import UIKit

enum SetPopOver {
    case myLocation
    case setLocation
    case mannerInfo
}

struct SetLocationOptionItem: LocationOptionItem {
    var text: String
    var font: UIFont
    var isSelected: Bool
    var setType: SetPopOver
}

struct SetMannerDetailInfo: MannerItem {
    var label: UILabel
    var font = UIFont.systemFont(ofSize: 13)
}
