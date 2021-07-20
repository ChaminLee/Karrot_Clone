//
//  LocationOptionViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit

protocol LocationOptionViewControllerDelegate: class {
    func OptionViewController(_ controller: LocationOptionViewController, didSelectOptionItem item: LocationOptionItem)
}

class LocationOptionViewController: UIViewController {

    var items = [[LocationOptionItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    private weak var tableView: UITableView?
    weak var delegate: LocationOptionViewControllerDelegate?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .popover
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UITableView(frame: .zero, style: .plain)
        tableView = view as? UITableView
//        tableView?.isScrollEnabled = false
        tableView?.alwaysBounceVertical = false

        tableView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView?.separatorColor = UIColor(named: CustomColor.separator.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 56
        let maxWidth = items.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 56 : $0 }
        let totalItems = CGFloat(items.flatMap{ $0 }.count)
        let totalHeight = totalItems * 44
        preferredContentSize = CGSize(width: maxWidth, height: totalHeight)
    }

}

extension LocationOptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = items[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = items[indexPath.section][indexPath.row]
        delegate?.OptionViewController(self, didSelectOptionItem: item)
        item.isSelected = !item.isSelected
        item.font = UIFont(name: "Helvetica-Bold", size: 13)!
        print(item)
        self.dismiss(animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return preferredContentSize.height / CGFloat(items.count)
//
//    }
}
