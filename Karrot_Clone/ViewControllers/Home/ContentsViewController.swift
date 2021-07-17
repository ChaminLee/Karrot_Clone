//
//  ContentsViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit

class ContentsViewController: UIViewController {

    let contentTable : UITableView = {
        let tv = UITableView(frame:  CGRect.zero, style: .plain)
        tv.register(ContentsCell.self, forCellReuseIdentifier: "ContentsCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
        view.backgroundColor = .white
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        view.addSubview(contentTable)
        
        contentTable.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setNavItems() {
        
    }
    
}


extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell",for: indexPath) as! ContentsCell
        
        return cell
    }
}
