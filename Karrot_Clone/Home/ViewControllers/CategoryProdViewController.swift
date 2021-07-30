//
//  CategoryProdViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/30.
//

import UIKit
import SnapKit

class CategoryProdViewController: UIViewController {

    var categoryTitle = ""
    
    let categoryProdTable: UITableView = {
        let tb = UITableView()
        tb.register(HomeCell.self, forCellReuseIdentifier: HomeCell.identifier)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topConfig()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("얍")
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    
    func topConfig() {
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
        
    }
    
    func config() {
        self.view.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        
        categoryProdTable.delegate = self
        categoryProdTable.dataSource = self
        
        view.addSubview(categoryProdTable)
        
        categoryProdTable.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension CategoryProdViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        
        cell.titleLabel.text = "카테고리별 필터링 데이터"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}
