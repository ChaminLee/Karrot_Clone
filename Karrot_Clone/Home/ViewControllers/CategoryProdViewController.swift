//
//  CategoryProdViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/30.
//

import UIKit
import SnapKit
import Firebase

class CategoryProdViewController: UIViewController {

    /// navigation title에 들어갈 카테고리명
    var categoryTitle = ""
    
    /// Firebase Realtime Database 세팅
    let ref = Database.database().reference()
    
    /// 같은 테이블뷰 사용하니 HomeCell 재사용
    let categoryProdTable: UITableView = {
        let tb = UITableView()
        tb.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        return tb
    }()
    
    var categoryProdData = [ProdData]() {
        didSet {
            self.categoryProdTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationButton()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = .none
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        fetchCategoryData()
    }
    
    
    private func setNavigationButton() {
        self.title = categoryTitle
        
        let nav = self.navigationItem
        
        let backButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            return bt
        }()
        
        let leftButton = UIBarButtonItem(customView: backButton)
        
        let searchButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            bt.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            return bt
        }()
        
        let rightButton = UIBarButtonItem(customView: searchButton)
        
        nav.leftBarButtonItem = leftButton
        nav.rightBarButtonItem = rightButton
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchButtonClicked() {
        /// [ ] SearchView로 이동
    }
    
    private func config() {
        self.view.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        
        categoryProdTable.delegate = self
        categoryProdTable.dataSource = self
        
        view.addSubview(categoryProdTable)
        
        categoryProdTable.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

/// ---------- TableView Setting ----------
extension CategoryProdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryProdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        cell.selectionStyle = .none
        
        /// upload 시간 기준으로 오름차순 정렬
        let data = categoryProdData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        
        cell.titleLabel.text = data.prodTitle
        /// Firebase Storage - image load가 너무 느림
//        fetchImage(imgView: cell.thumbnail, name: "me")
        cell.thumbnail.image = UIImage(named: data.prodImage)
        cell.locationLabel.text = data.location
        cell.priceLabel.text = data.price
        
        /// [ ] 시간 케이스별 정리 필요  ( ~ 일 전, ~ 시간 전, ~ 분 전, + 끌올)
        cell.timeLabel.text = " ・ " + "\(data.uploadTime)분 전"
        
        /// 개수에 따라 초기화 or 데이터 할당
        if data.heartNum > 0 {
            cell.heartLabel.text = "\(data.heartNum)"
            cell.heartIcon.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.stackView.isHidden = false
            cell.heartView.isHidden = false
            cell.heartLabel.isHidden = false
            cell.heartIcon.isHidden = false
        } else {
            cell.heartView.isHidden = true
        }
        
        if data.chatNum > 0 {
            cell.chatLabel.text = "\(data.chatNum)"
            cell.chatIcon.setImage(UIImage(systemName: "bubble.left.and.bubble.right"), for: .normal)
            cell.stackView.isHidden = false
            cell.chatView.isHidden = false
            cell.chatIcon.isHidden = false
            cell.chatLabel.isHidden = false
        } else {
            cell.chatView.isHidden = true
        }
        
        if data.replyNum > 0 {
            cell.replyLabel.text = "\(data.replyNum)"
            cell.replyIcon.setImage(UIImage(systemName: "message"), for: .normal)
            cell.stackView.isHidden = false
            cell.replyView.isHidden = false
            cell.replyIcon.isHidden = false
            cell.replyLabel.isHidden = false
        } else {
            cell.replyView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 선택 이후 선택 취소
        tableView.deselectRow(at: indexPath, animated: true)
        /// 선택된 데이터 1개 넘겨줌
        let data = categoryProdData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        let vc = ContentsViewController(items: [data])
        /// 하단 뷰에 들어갈 가격 데이터 전달
        vc.priceLabel.text = data.price
                
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CategoryProdViewController {
    func fetchCategoryData() {
        DispatchQueue.main.async {
            self.categoryProdData.removeAll()
            
            /// 카테고리별로 필터링하여 쿼리 날리기
            let query = self.ref.queryOrdered(byChild: "category")
                .queryEqual(toValue: self.categoryTitle)
            
            query.observe(.value) { snapshot in
                if snapshot.childrenCount > 1 {
                    if let result = snapshot.value as? [String:Any] {
                        result.values.forEach { item in
                            let data = ProdData(dictionary: item as! [String : Any])
                            self.categoryProdData.append(data)
                        }
                    }
                    /// 1개 일 경우 json 구조가 다르게 들어옴 > 별도 처리
                } else {
                    if let result = snapshot.value as? [[String:Any]] {
                        result.forEach { item in
                            let data = ProdData(dictionary: item as! [String : Any])
                            self.categoryProdData.append(data)
                        }
                    }
                }
            }
        }
    }
}
