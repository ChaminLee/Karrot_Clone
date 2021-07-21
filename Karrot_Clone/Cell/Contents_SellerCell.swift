//
//  Contents_Seller.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit
import SnapKit

class Contents_SellerCell: UITableViewCell {
    
    static let identifier = "Contents_SellerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "정자동불주먹님의 판매 상품" // \(seller.name)
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 14)
        return lb
    }()
    
    let moreButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("더보기", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        return bt
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(Contents_Seller_ProdCell.self, forCellWithReuseIdentifier: Contents_Seller_ProdCell.identifier)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        return cv
    }()
        
    
    func config() {
        [titleLabel, moreButton, collectionView].forEach { item in
            contentView.addSubview(item)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(20)
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(400)
        }
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Contents_SellerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 5.0
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let width = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
        
        return CGSize(width: width, height: width)//collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_Seller_ProdCell.identifier, for: indexPath) as! Contents_Seller_ProdCell
        
//        cell.prodImage.image = UIImage(named: "당근이")
//        cell.prodLabel.text = "ASDFASDFASF"
        
        return cell
    }

//    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
//        
//        
//        collectionView.layoutIfNeeded()
//        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
//        if self.collectionView.numberOfItems(inSection: 0) < 4 {
//            return CGSize(width: contentSize.width, height: 120)
//        }
//        
//        return CGSize(width: contentSize.width, height: contentSize.height + 20)
//    }
//    
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
//            self.invalidateIntrinsicContentSize()
//        }
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        return collectionView.contentSize
//    }
    
    
}
