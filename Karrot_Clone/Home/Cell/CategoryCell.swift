//
//  CategoryCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/28.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let categoryImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "당근이")
        return img
    }()
    
    let categoryTitle: UILabel = {
        let lb = UILabel()
        lb.text = "디지털기기"
        lb.font = UIFont(name: "Helvetica", size: 13)
        lb.textAlignment = .center
        return lb
    }()
    
    
    func config() {
        [categoryImage,categoryTitle].forEach { item in
            addSubview(item)
        }
        
        categoryImage.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(10)
        }
        categoryTitle.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(categoryImage.snp.bottom).offset(10)
        }
    }
}
