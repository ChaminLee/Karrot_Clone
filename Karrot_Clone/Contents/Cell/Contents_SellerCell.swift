//
//  Contents_Seller.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit
import SnapKit
import Firebase

//protocol usersProdFetch {
//    <#requirements#>
//}

class Contents_SellerCell: UITableViewCell {
    
    let ref = Database.database().reference()
    
    var userID = ""
    var cnt = 0
    var height = 0
    
    var usersProd = [ProdData]()
    static let identifier = "Contents_SellerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        getUsersProds()
        config()
    }
    
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 15)
        return lb
    }()
    
    let moreButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("더보기", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
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
//            $0.height.equalTo(360)
//            if cnt > 2 {
//                $0.height.equalTo(360)
//            } else {
//                $0.height.equalTo(160)
//            }
            
        }
        self.setNeedsLayout()
        print("콘피그중입니다")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userID = ""
    }
}

extension Contents_SellerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersProd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 6.0

        let numberOfItemsPerRow: CGFloat = 2.0

        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfItemsPerRow + 1)) / numberOfItemsPerRow

        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_Seller_ProdCell.identifier, for: indexPath) as! Contents_Seller_ProdCell
        
        let data = usersProd[indexPath.row]
        cell.prodImage.image = UIImage(named: data.prodImage)
        cell.prodLabel.text = data.prodTitle 
        cell.priceLabel.text = data.price
        
        return cell
    }
    
    
    
}

extension Contents_SellerCell {
    func getUsersProds() {
        
        DispatchQueue.main.async {
            self.usersProd.removeAll()
            
            let query = self.ref.queryOrdered(byChild: "userID")
                .queryEqual(toValue: self.userID)
            
            query.observe(.value) { snapshot in
//                print(snapshot.value as? [String:Any])
                if let result = snapshot.value as? [String:Any] {
                    result.values.forEach { item in
                        let data = ProdData(dictionary: item as! [String : Any])
                        self.usersProd.append(data)
                    }
                    self.collectionView.reloadData()
                }
                self.cnt = self.usersProd.count
                print(self.cnt)
                
                if self.usersProd.count < 2 {
                    self.height = 160
                } else {
                    self.height = 360
                }
                
                print(" 넌 뭐니 \(self.height)")
                
            }
            print("높이높이 :\(self.height) \(self.cnt)")
            self.collectionView.snp.makeConstraints {
//                $0.height.equalTo(height)
                $0.height.equalTo(500)
            }
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            
        }
    }
    
}
