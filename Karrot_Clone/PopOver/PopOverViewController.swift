//
//  LocationOptionViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit
import SnapKit

/// PopOver에서 선택된 지역명 넘겨주기
protocol PopOverLocationSelectedDelegate: AnyObject {
    func selectedLocation(controller: PopOverViewController, didSelectItem name: String)
}

/// [ ] 지역선택 action (구현 필요)
protocol LocationOptionViewControllerDelegate: AnyObject {
    func OptionViewController(_ controller: PopOverViewController, didSelectOptionItem item: LocationOptionItem)
}

class PopOverViewController: UIViewController {

    /// 지역선택
    var items = [[LocationOptionItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    
    /// 매너온도
    var manners = [[MannerItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
        
    private weak var tableView: UITableView?
    
    var delegate: LocationOptionViewControllerDelegate?
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
        /// 바운싱 제거
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
        
        /// window의 글쓰기 버튼 관리
        UIApplication.shared.windows.last!.alpha = 0.3
        UIApplication.shared.windows.last!.isUserInteractionEnabled = false
        
        self.preferredContentSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        /// 매너온도는 dimmed X
        if manners.count == 0 {
            self.presentingViewController?.view.alpha = 0.3
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /// window의 글쓰기 버튼 관리
        UIApplication.shared.windows.last!.alpha = 1
        UIApplication.shared.windows.last!.isUserInteractionEnabled = true
        
        self.presentingViewController?.view.alpha = 1
        
        /// Home - LocationArrowButton을 다시 돌려놔라!
        NotificationCenter.default.post(name: .rotateBack, object: nil)
    }
    
    /// 콘텐츠 사이즈 계산
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 56
        var width: CGFloat = 0, height: CGFloat = 0
        
        if items.flatMap {$0}.count != 0 {
            width = items.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 56 : $0 }
            let totalItems = CGFloat(items.flatMap{ $0 }.count)
            height = totalItems * 44
        }
        preferredContentSize = CGSize(width: width, height: height)
    }

}

/// ---------- TableView Setting ----------
extension PopOverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count == 0 ? manners.count : items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count == 0 ? 1 : items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        /// 매너온도 구성 세팅
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
        /// 지역선택 구성 세팅
        } else {
            let item = items[indexPath.section][indexPath.row]
            cell.configure(with: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// [ ] - 지역 선택 개선 필요
        if items.count > 0 {
            var item = items[indexPath.section][indexPath.row]
            delegate?.OptionViewController(self, didSelectOptionItem: item)
            
            if indexPath.row == items[indexPath.section].count - 1 {
                /// 지역 설정 뷰
                DispatchQueue.main.async {
                    guard let pvc = self.presentingViewController else { return }
                    let vc = NewLocationViewController()
                    vc.modalPresentationStyle = .fullScreen
                    
                    self.dismiss(animated: true) {
                        pvc.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                /// 지역 선택시
                self.selectedDelegate?.selectedLocation(controller: self, didSelectItem: item.text)
                                
                /// [ ] 선택된 지역으로 변경 필요
                
                self.dismiss(animated: true) {
                    print("reloading")
                }
                
                NotificationCenter.default.post(name: .locationChangedToast, object: nil)
                
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



