//
//  Contents_Seller_Prod.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import UIKit
import SnapKit

class Contents_Seller_ProdCell: UICollectionViewCell {
    
    static let identifier = "Contents_Seller_ProdCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let prodImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        img.image = UIImage(named: "당근이")?.scalePreservingAspectRatio(targetSize: CGSize(width: 40, height: 40))
        img.layer.masksToBounds = false
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
            
        return img
    }()
    
    let prodLabel: UILabel = {
        let lb = UILabel()
        lb.text = "나이키 덩크로우 범고래 270사이즈 판매합니다."
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 1
        lb.font = UIFont(name: "Helvetica", size: 12)
        return lb
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "115,000원"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 1
        lb.font = UIFont(name: "Helvetica-Bold", size: 12)
        return lb
    }()
    
    func config() {
        [prodImage, prodLabel, priceLabel].forEach { item in
            contentView.addSubview(item)
        }
        
        prodImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        prodLabel.snp.makeConstraints {
            $0.top.equalTo(prodImage.snp.bottom).offset(10)
            $0.leading.equalTo(prodImage.snp.leading)
            $0.trailing.equalTo(prodImage.snp.trailing)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(prodLabel.snp.bottom).offset(10)
            $0.leading.equalTo(prodLabel.snp.leading)
            $0.trailing.equalTo(prodImage.snp.trailing)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
}
