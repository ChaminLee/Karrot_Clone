//
//  HomeViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let hometable : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeTable()
        setNavMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hometable.frame = view.bounds
    }
    
    func setHomeTable() {
        hometable.delegate = self
        hometable.dataSource = self
        
        view.addSubview(hometable)
        
        hometable.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        hometable.refreshControl = UIRefreshControl()
        hometable.refreshControl?.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
        
        
    }
    
    @objc func pullRefresh(_ sender: Any) {
        print("업데이트중")
        self.hometable.reloadData()
        hometable.refreshControl?.endRefreshing()
        
    }
    
    func setNavMenu() {
        UINavigationBar.appearance().barTintColor = UIColor(named: CustomColor.background.rawValue)
        UINavigationBar.appearance().isTranslucent = false
        
        // left
        let locationButton : UIButton = {
            let bt = UIButton()
            bt.setTitle("정자1동", for: .normal)
            bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
            bt.setTitleColor(UIColor(named: CustomColor.text.rawValue), for: .normal)
            bt.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
            return bt
        }()
        
        let locationArrowButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//            let size: CGFloat = 10
//            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
            return bt
        }()
        
        let leftStackView = UIStackView.init(arrangedSubviews: [locationButton,locationArrowButton])
        stackViewConfig(leftStackView)
        leftStackView.spacing = 10
        
        let navitem = self.navigationItem
            
        let leftSection = UIBarButtonItem(customView: leftStackView)
       
        navitem.leftBarButtonItem = leftSection
        
        // right
        let searchButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
            return bt
        }()
        
        let categoryButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
            return bt
        }()
        
        let bellButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "bell"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(bellClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStackView = UIStackView.init(arrangedSubviews: [searchButton, categoryButton, bellButton])
        stackViewConfig(rightStackView)
        rightStackView.spacing = 18
        
        let rightSection = UIBarButtonItem(customView: rightStackView)
        navitem.rightBarButtonItem = rightSection
        
    }
    
    func stackViewConfig(_ stackview: UIStackView) {
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
    }

    @objc func locationItemClicked() {
        print("정자 1동!")
    }
    
    @objc func searchClicked() {
        print("검색!")
    }
    
    @objc func categoryClicked() {
        print("카테고리!")
    }
    
    @objc func bellClicked() {
        print("알림!")
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = "캐논 g7x mark3 풀박스 2020년 10월 구입 제품 팔아요 캐논 g7x mark3 풀박스"
        cell.thumbnail.image = UIImage(named: "당근이")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContentsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
//        DispatchQueue.main.async {
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}
