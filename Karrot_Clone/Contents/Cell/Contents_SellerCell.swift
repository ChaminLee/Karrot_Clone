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

/// 유저의 다른 상품 클릭시 상품뷰로 이동시키기 위한 프로토콜
protocol cellToPushNavDelegate: AnyObject {
    func pushNav(viewController: UIViewController)
}

class Contents_SellerCell: UITableViewCell {
    
    /// Firebase Realtime Database 세팅
    let ref = Database.database().reference()
    
    weak var userDelegate: cellToPushNavDelegate?
    /// 유저 아이디
    var userID = ""

    var usersProd = [ProdData]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    static let identifier = "Contents_SellerCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fetchUsersProdsData()
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
        cv.register(Contents_ProdCell.self, forCellWithReuseIdentifier: Contents_ProdCell.identifier)
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
            /// [ ] userProd 개수 관리 해야함!
            if usersProd.count > 2 {
                $0.height.equalTo(360)
            } else {
                $0.height.equalTo(160)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// ---------- CollectionView Setting ----------
extension Contents_SellerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersProd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 6.0

        let numberOfItemsPerRow: CGFloat = 2.0

        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfItemsPerRow + 1)) / numberOfItemsPerRow

        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_ProdCell.identifier, for: indexPath) as! Contents_ProdCell
        
        let data = usersProd.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        cell.prodImage.image = UIImage(named: data.prodImage)
        cell.prodLabel.text = data.prodTitle 
        cell.priceLabel.text = data.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 선택된 데이터 1개 넘겨줌
        let data = usersProd.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        let vc = ContentsViewController(items: [data])
        /// 하단 뷰에 들어갈 가격 데이터 전달
        vc.priceLabel.text = data.price
                
        self.userDelegate?.pushNav(viewController: vc)
    }
}

extension Contents_SellerCell {
    func fetchUsersProdsData() {
        DispatchQueue.main.async {
            self.usersProd.removeAll()
            
            let query = self.ref.queryOrdered(byChild: "userID")
                .queryEqual(toValue: self.userID).queryLimited(toLast: 4)
            
            query.observe(.value) { snapshot in
                print(snapshot.value as? [String:Any])
                if snapshot.childrenCount > 1 {
                    if let result = snapshot.value as? [String:Any] {
                        result.values.forEach { item in
                            let data = ProdData(dictionary: item as! [String : Any])
                            self.usersProd.append(data)
                        }
                    }
                    /// 1개 일 경우 json 구조가 다르게 들어옴 > 별도 처리
                } else {
                    if let result = snapshot.value as? [[String:Any]] {
                        result.forEach { item in
                            let data = ProdData(dictionary: item as! [String : Any])
                            self.usersProd.append(data)
                        }
                    }
                }
            }
        }
    }
}
