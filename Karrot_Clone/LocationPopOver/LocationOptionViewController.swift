//
//  LocationOptionViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit

protocol LocationOptionViewControllerDelegate: class {
    func OptionViewController(_ controller: LocationOptionViewController, didSelectOptionItem item: LocationOptionItem)
    func MannerOptionViewController(_ controller: LocationOptionViewController, didSelectOptionItem item: MannerDetailnfo)
}

class LocationOptionViewController: UIViewController {

    var items = [[LocationOptionItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    var manners = [[MannerDetailnfo]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    private weak var tableView: UITableView?
    weak var delegate: LocationOptionViewControllerDelegate?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .popover
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UITableView(frame: .zero, style: .plain)
        tableView = view as? UITableView
//        tableView?.isScrollEnabled = false
//        tableView?.alwaysBounceVertical = false

        tableView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if items.count != 0 {
            tableView?.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        } else {
            tableView?.separatorColor = UIColor(named: CustomColor.karrot.rawValue)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 56
        var width: CGFloat = 0, height: CGFloat = 0
        
        if items.flatMap {$0}.count == 0 {
//            width = manners.flatMap{ $0 }.reduce(0) { $1.sizeForManneerText().width + approxAccessoryViewWidth > $0 ? $1.sizeForManneerText().width + 56 : $0 }
//            let totalItems = CGFloat(manners.flatMap{ $0 }.count )
//            height = totalItems * 44
            width = self.view.frame.width / 2
            height = 80
        } else {
            width = items.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 56 : $0 }
            let totalItems = CGFloat(items.flatMap{ $0 }.count)
            height = totalItems * 44
        }
        preferredContentSize = CGSize(width: width, height: height)
    }

}

extension LocationOptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count == 0 ? manners.count : items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count == 0 ? 1 : items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.selectionStyle = .none
        print(items.count)
        if items.count == 0 {
            let mannerItem = manners[indexPath.section][indexPath.row]
            cell.configManner(with: mannerItem)
            cell.backgroundColor = UIColor(named: CustomColor.karrot.rawValue)
            cell.textLabel?.textColor = .white
        } else {
            let item = items[indexPath.section][indexPath.row]
            cell.configure(with: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if items.count == 0 {
            var mannerItem = manners[indexPath.section][indexPath.row]
            delegate?.MannerOptionViewController(self, didSelectOptionItem: mannerItem)
        } else {
            var item = items[indexPath.section][indexPath.row]
            delegate?.OptionViewController(self, didSelectOptionItem: item)
        }
        
//        item.isSelected = !item.isSelected
//        item.font = UIFont(name: "Helvetica-Bold", size: 13)!
        self.dismiss(animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return preferredContentSize.height / CGFloat(items.count)
//
//    }
}
