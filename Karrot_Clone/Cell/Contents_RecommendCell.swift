//
//  Contents_RecommendCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/22.
//

import UIKit

class Contents_RecommendCell: UITableViewCell {
    
    var recommendItems = [OtherProduct]()
    static let identifier = "Contents_RecommendCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setRecommendSampleData()
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
    
    var collectionView: UICollectionView = {
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
            $0.height.equalTo(1950)
            
            
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Contents_RecommendCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendItems.count
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
        
        let data = recommendItems[indexPath.row]
        
        cell.prodImage.image = UIImage(named: data.imgName)
        cell.prodLabel.text = data.title
        cell.priceLabel.text = data.price
        
        return cell
    }
    
}

extension Contents_RecommendCell {
    func setRecommendSampleData() {
        recommendItems.append(contentsOf: [
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원"),
            OtherProduct(imgName: "당근이4", title: "당근이4 팝니다 빨리빨리 주워가세요", price: "2백만원"),
            OtherProduct(imgName: "당근이5", title: "당근이5 팝니다 빨리빨리 주워가세요", price: "3백만원"),
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원"),
            OtherProduct(imgName: "당근이4", title: "당근이4 팝니다 빨리빨리 주워가세요", price: "2백만원"),
            OtherProduct(imgName: "당근이5", title: "당근이5 팝니다 빨리빨리 주워가세요", price: "3백만원"),
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원"),
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원"),
            OtherProduct(imgName: "당근이4", title: "당근이4 팝니다 빨리빨리 주워가세요", price: "2백만원"),
            OtherProduct(imgName: "당근이5", title: "당근이5 팝니다 빨리빨리 주워가세요", price: "3백만원"),
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원"),
            OtherProduct(imgName: "당근이4", title: "당근이4 팝니다 빨리빨리 주워가세요", price: "2백만원"),
            OtherProduct(imgName: "당근이5", title: "당근이5 팝니다 빨리빨리 주워가세요", price: "3백만원"),
            OtherProduct(imgName: "당근이", title: "당근이 팝니다", price: "10,000원"),
            OtherProduct(imgName: "당근이2", title: "당근이2 팝니다 빨리빨리 주워가세요", price: "125,000원")
        ])
    }
}
