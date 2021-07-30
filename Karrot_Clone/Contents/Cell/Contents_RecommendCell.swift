//
//  Contents_RecommendCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/22.
//

import UIKit
import SnapKit
import Firebase

class Contents_RecommendCell: UITableViewCell {
    
    let ref = Database.database().reference()
    
    var recommendProd = [ProdData]()
    static let identifier = "Contents_RecommendCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setRecommendSampleData()
        fetchData()
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
        return recommendProd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 6.0
        
        let numberOfItemsPerRow: CGFloat = 2.0
        let numberOfItemsPerHeight: CGFloat = 10.0
        
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfItemsPerRow + 1)) / numberOfItemsPerRow
        let height = (collectionView.bounds.height - layout.minimumLineSpacing * (numberOfItemsPerHeight + 2)) / numberOfItemsPerHeight
        
        return CGSize(width: width, height: height)
    }
    
    /// 위에서 AutoLayout으로 이미 sectionInset을 잡은거나 다름없음
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Contents_Seller_ProdCell.identifier, for: indexPath) as! Contents_Seller_ProdCell
        
        let data = recommendProd[indexPath.row]
        
        cell.prodImage.image = UIImage(named: data.prodImage)
        cell.prodLabel.text = data.prodTitle
        cell.priceLabel.text = data.price
        
        return cell
    }
    
}

extension Contents_RecommendCell {
    func setRecommendSampleData() {
//        recommendProd.append(contentsOf: [
//            ProdData(prodImage: "당근이", prodTitle: "추천 당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
//            ProdData(prodImage: "당근이3", prodTitle: "다른 당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이7", prodTitle: "당근이 넘버투 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이5", prodTitle: "당근이 시즌품 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5"),
//            ProdData(prodImage: "당근이", prodTitle: "당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
//            ProdData(prodImage: "당근이3", prodTitle: "다른 당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이7", prodTitle: "당근이 넘버투 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이5", prodTitle: "당근이 시즌품 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5"),
//            ProdData(prodImage: "당근이", prodTitle: "당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
//            ProdData(prodImage: "당근이3", prodTitle: "다른 당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이7", prodTitle: "당근이 넘버투 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이5", prodTitle: "당근이 시즌품 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5"),
//            ProdData(prodImage: "당근이", prodTitle: "당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
//            ProdData(prodImage: "당근이3", prodTitle: "다른 당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이7", prodTitle: "당근이 넘버투 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이5", prodTitle: "당근이 시즌품 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5"),
//            ProdData(prodImage: "당근이", prodTitle: "당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
//            ProdData(prodImage: "당근이3", prodTitle: "다른 당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이7", prodTitle: "당근이 넘버투 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
//            ProdData(prodImage: "당근이5", prodTitle: "당근이 시즌품 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5")
//        ])
    }
    
    func fetchData() {
        print("firebase 데이터 패치중")
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
