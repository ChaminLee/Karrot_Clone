//
//  Contents_RecommendCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/22.
//

import UIKit
import SnapKit
import Firebase

/// 추천 상품 / 함께 본 상품 클릭시 상품뷰로 이동시키기 위한 프로토콜
protocol recommendPushNavDelegate {
    func recommendPushNav(viewController: UIViewController)
}

class Contents_RecommendCell: UITableViewCell {
    /// Firebase Realtime Database 세팅
    let ref = Database.database().reference()
    
    var recommendDelegate: recommendPushNavDelegate?
    var recommendProd = [ProdData]() 
    
    static let identifier = "Contents_RecommendCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fetchRecommendProdData()
        config()
    }
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 15)
        return lb
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(Contents_ProdCell.self, forCellWithReuseIdentifier: Contents_ProdCell.identifier)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        return cv
    }()
        
    
    func config() {
        [titleLabel, collectionView].forEach { item in
            contentView.addSubview(item)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(15)
            $0.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1900)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// ---------- CollectionView Setting ----------
extension Contents_RecommendCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendProd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 6.0
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let numberOfItemsPerHeight: CGFloat = 10.0
        
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfItemsPerRow + 1)) / numberOfItemsPerRow
        let height = (collectionView.bounds.height - layout.minimumLineSpacing * (numberOfItemsPerHeight + 1)) / numberOfItemsPerHeight
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_ProdCell.identifier, for: indexPath) as! Contents_ProdCell
        
        let data = recommendProd.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        
        cell.prodImage.image = UIImage(named: data.prodImage)
        cell.prodLabel.text = data.prodTitle
        cell.priceLabel.text = data.price
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 선택된 데이터 1개 넘겨줌
        let data = recommendProd.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        let vc = ContentsViewController(items: [data])
        /// 하단 뷰에 들어갈 가격 데이터 전달
        vc.priceLabel.text = data.price
                
        self.recommendDelegate?.recommendPushNav(viewController: vc)
    }
    
}

extension Contents_RecommendCell {
    func fetchRecommendProdData() {
        self.recommendProd.removeAll()
        
        DispatchQueue.main.async {
            let query = self.ref.queryLimited(toFirst: 20)
            query.observeSingleEvent(of: .value) { snapShot in
                if let result = snapShot.value as? [[String:Any]] {
                    result.forEach { item in
                        let data = ProdData(dictionary: item as! [String:Any])
                        self.recommendProd.append(data)
                    }
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
}
