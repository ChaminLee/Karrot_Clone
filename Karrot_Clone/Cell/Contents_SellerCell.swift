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

    var collectionViewObserver: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
        addCustomObserver()
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
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(Contents_Seller_ProdCell.self, forCellWithReuseIdentifier: Contents_Seller_ProdCell.identifier)
        cv.backgroundColor = .clear
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
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(20)
//            $0.height.equalTo(200)
        }
        
    }
    
    func addCustomObserver() {
        collectionViewObserver = collectionView.observe(\.contentSize, changeHandler: { [weak self] (collectionView, change) in
            self?.collectionView.invalidateIntrinsicContentSize()
            self?.layoutIfNeeded()
        })
    }
    
    deinit {
        collectionViewObserver = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Contents_SellerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / 2 - 10
        let height = width * (2 / 3)
        
        return CGSize(width: width, height: width)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
//    }
    
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return collectionView.contentSize
    }
    
    
}
