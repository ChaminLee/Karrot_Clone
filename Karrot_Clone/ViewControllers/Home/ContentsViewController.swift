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
        let tv = UITableView(frame:  CGRect.zero, style: .grouped)
        tv.register(Contents_HeaderCell.self, forHeaderFooterViewReuseIdentifier: "ContentsHeaderCell")
        tv.register(ContentsCell.self, forCellReuseIdentifier: "ContentsCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        
        tv.contentInsetAdjustmentBehavior = .never
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
            $0.bottom.leading.trailing.equalToSuperview()
//            $0.top.equalToSuperview().offset(-90)
            $0.top.equalTo(view.safeAreaInsets.top)
        }
        
    }
    
    func setNavItems() {
        
    }
    
}


extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell",for: indexPath) as! ContentsCell
        cell.indentationLevel = 2
        
        return cell
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
}
