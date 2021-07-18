//
//  Contents_Seller.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit
import SnapKit

class Contents_Seller: UITableViewCell {
    
    static let identifier = "Contents_Seller"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "정자동불주먹님의 판매 상품" // \(seller.name)
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 13)
        return lb
    }()
    
    let moreButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("더보기", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        return bt
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(Contents_Seller_Prod.self, forCellWithReuseIdentifier: Contents_Seller_Prod.identifier)
        cv.backgroundColor = .clear
        return cv
    }()
        
    
    func config() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [titleLabel, moreButton, collectionView].forEach { item in
            contentView.addSubview(item)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(15)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Contents_Seller: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: frame.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_Seller_Prod.identifier, for: indexPath) as! Contents_Seller_Prod
        
        return cell
    }
    
}
