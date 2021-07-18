//
//  ContentsViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit

class ContentsViewController: UIViewController, UIGestureRecognizerDelegate {

    let contentTable : UITableView = {
        let tv = UITableView(frame:  CGRect.zero, style: .grouped)
        tv.register(Contents_HeaderCell.self, forHeaderFooterViewReuseIdentifier: Contents_HeaderCell.identifier)
        tv.register(Contents_UserInfoCell.self, forCellReuseIdentifier: Contents_UserInfoCell.identifier)
        tv.register(Contents_MainText.self, forCellReuseIdentifier: Contents_MainText.identifier)
        tv.register(Contents_Report.self, forCellReuseIdentifier: Contents_Report.identifier)
        tv.register(Contents_Seller.self, forCellReuseIdentifier: Contents_Seller.identifier)
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setNavItems()
        print("콘텐츠 뷰디ㅡㄷ로드")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTable.frame = view.bounds
    }
    
    func config() {
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
        view.backgroundColor = .white
        
//        let contentsNavigationController = UINavigationController(rootViewController: ContentsViewController())
//        contentsNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        contentsNavigationController.navigationBar.isTranslucent = true
//        contentsNavigationController.navigationBar.shadowImage = UIImage()
//        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        
        view.addSubview(contentTable)
        
        contentTable.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top)
        }
        
    }
    
    func setNavItems() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let navitem = self.navigationItem
        
        // left
        let backButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            //            let size: CGFloat = 10
            //            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        
            
        let leftSection = UIBarButtonItem(customView: backButton)
       
        navitem.leftBarButtonItem = leftSection
        
        // right
        let shareButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let moreButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStack = UIStackView.init(arrangedSubviews: [shareButton,moreButton])
            
        rightStack.stackViewConfig(rightStack)
        rightStack.spacing = 15
        let rightSection = UIBarButtonItem(customView: rightStack)
       
        navitem.rightBarButtonItem = rightSection
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func shareButtonClicked() {
        print("share")
    }
    @objc func moreButtonClicked() {
        print("more")
    }
    
    
    
}


extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_UserInfoCell",for: indexPath) as! Contents_UserInfoCell
            cell.selectionStyle = .none
            
            cell.idLabel.text = "정자동불주먹"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_MainText",for: indexPath) as! Contents_MainText
            cell.selectionStyle = .none
                    
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_Report",for: indexPath) as! Contents_Report
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_Seller",for: indexPath) as! Contents_Seller
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_Seller",for: indexPath) as! Contents_Seller
            cell.selectionStyle = .none
            return cell
        }
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_UserInfoCell",for: indexPath) as! Contents_UserInfoCell
//            cell.selectionStyle = .none
//
//            cell.idLabel.text = "정자동불주먹"
//
//            return cell
//        } else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell",for: indexPath) as! ContentsCell
//            cell.selectionStyle = .none
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // HeaderView

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContentsHeaderCell") as? Contents_HeaderCell
        
        header?.headerConfig()
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
