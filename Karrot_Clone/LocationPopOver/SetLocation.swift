//
//  LocationOption.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import Foundation
import UIKit

enum SetLocation {
    case myLocation
    case setLocation
    case mannerInfo
}

struct SetLocationOptionItem: LocationOptionItem {
    var text: String
    var font: UIFont //= UIFont.systemFont(ofSize: 13)
    var isSelected: Bool
    var setType: SetLocation
}

struct SetMannerDetailInfo: MannerDetailnfo {
    var label: UILabel
    var font = UIFont.systemFont(ofSize: 13)
}
