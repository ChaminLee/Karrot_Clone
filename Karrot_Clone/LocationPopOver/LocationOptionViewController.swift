//
//  LocationOptionViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit
import SnapKit

protocol PopOverLocationSelectedDelegate: AnyObject {
    func selectedLocation(controller: LocationOptionViewController, didSelectItem name: String)
}

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
    var selectedDelegate: PopOverLocationSelectedDelegate?
    
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
        tableView?.alwaysBounceVertical = false

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.windows.last!.alpha = 0.3
        
        UIApplication.shared.windows.last!.isUserInteractionEnabled = false
        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if manners.count == 0 {
            self.presentingViewController?.view.alpha = 0.3
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.windows.last!.alpha = 1
        UIApplication.shared.windows.last!.isUserInteractionEnabled = true
        self.presentingViewController?.view.alpha = 1

    }
    

    
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 56
        var width: CGFloat = 0, height: CGFloat = 0
        
        if items.flatMap {$0}.count == 0 {
            width = 250
            height = 130
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
            
            let testView: UIView = {
                let view = UIView()
                return view
            }()
            
            let label: UILabel = {
                let lb = UILabel()
                lb.text = "매너온도는 당근마켓 사용자로부터 받은 칭찬, 후기, 비매너 평가, 운영자 징계 등을 통해 종합해서 만든 매너 지표에요"
                lb.numberOfLines = 0
                lb.font = UIFont(name: "Helvetica", size: 14)
                lb.textColor = .white
                return lb
            }()
            
            testView.addSubview(label)
            cell.addSubview(testView)
            
            label.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(10)
            }
            
            testView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            let item = items[indexPath.section][indexPath.row]
            cell.textLabel?.tag
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
            
            if indexPath.row == items[indexPath.section].count - 1 {
                // 지역 설정 뷰
                DispatchQueue.main.async {
                    guard let pvc = self.presentingViewController else { return }
                    let vc = NewLocationViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.dismiss(animated: true) {
                        pvc.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                print("내가 고른 장소 : \(item.text)")
                self.selectedDelegate?.selectedLocation(controller: self, didSelectItem: item.text)
                
                let vc = HomeViewController()
                vc.locationData = item.text 
                
                item.font = UIFont(name: "Helvetica-Bold", size: 14)!
                item.isSelected = true
                self.dismiss(animated: true) {
                    print("reloading")
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
