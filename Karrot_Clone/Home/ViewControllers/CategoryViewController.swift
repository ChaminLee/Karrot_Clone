//
//  CategoryViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/28.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {

    let categoryTitleList = ["인기매물", "디지털기기", "생활가전","가구/인테리어","유아동","생활/가공식품","유아도서","스포츠/레저","여성잡화","여성의류","남성패션/잡화","게임/취미",
    "뷰티/미용","반려동물용품","도서/티켓/음반","식물","기타 중고물품", "삽니다"]
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavButton()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    func setNavButton() {
        let navitem = self.navigationItem
        
        let backButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            return bt
        }()
        
        let leftSection = UIBarButtonItem(customView: backButton)
       
        navitem.leftBarButtonItem = leftSection
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func config() {
        self.title = "카테고리"
        view.backgroundColor = .white
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        
        cell.categoryTitle.text = categoryTitleList[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row: CGFloat = 3
        let col: CGFloat = 6
        
        let width = self.view.frame.width / (row + 1)
        let height = self.view.frame.height / (col + 1)
        
        return CGSize(width: width, height: height)
    }
    
}
