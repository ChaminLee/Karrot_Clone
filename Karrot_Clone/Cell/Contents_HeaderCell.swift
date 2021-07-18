//
//  Contents_HeaderCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import UIKit
import SnapKit

class Contents_HeaderCell: UITableViewHeaderFooterView {
    
    static let identifier = "ContentsHeaderCell"
    
    let prodImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "당근이")
        
        return img
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headerConfig() {
        let view = UIView(frame: .zero)
        
        contentView.addSubview(view)
        view.addSubview(prodImage)
        
        view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        prodImage.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
}
