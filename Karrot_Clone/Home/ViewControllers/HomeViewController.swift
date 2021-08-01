//
//  HomeViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit
import SnapKit
import Foundation
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController {
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    var prodData = [ProdData]()

    
    var locationData = "지역을 선택해주세요"
        
    let hometable : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeTable()
        setNavMenu()
        addLocationList()
        setToast()
        
        /// LocationArrowButton 돌려두라는 것 수신!
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .rotateBack, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewToast), name: .locationChangedToast, object: nil)
    }
    
    /// LocationArrowButton rotate back
    @objc func rotate() {
        UIView.animate(withDuration: 0.25) {
            self.locationArrowButton.transform = CGAffineTransform.identity
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        navStyle()
        /// 글쓰기 버튼은 홈에서만 보이도록 - 원복
        UIApplication.shared.windows.last!.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// 글쓰기 버튼은 홈에서만 보이도록 - 제거
        UIApplication.shared.windows.last!.isHidden = true
    }
    
    
    private func navStyle() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.background.rawValue)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.alpha = 1
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
        hometable.refreshControl?.tintColor = UIColor(named: CustomColor.karrot.rawValue)
        hometable.refreshControl?.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
    }
    
    @objc func pullRefresh(_ sender: Any) {
        print("업데이트중")
        self.hometable.reloadData()
        hometable.refreshControl?.endRefreshing()
    }
    
    /// Left Nav Button
    let locationButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("중앙동", for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 19)
        bt.setTitleColor(UIColor(named: CustomColor.text.rawValue), for: .normal)        
        return bt
    }()
    
    let locationArrowButton : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        bt.tintColor = UIColor(named: CustomColor.text.rawValue)
        bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let size: CGFloat = 15
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.imageView?.contentMode = .scaleAspectFit
        return bt
    }()
    
    func setNavMenu() {
        UINavigationBar.appearance().barTintColor = UIColor(named: CustomColor.background.rawValue)
        let navitem = self.navigationItem
        
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        
        /// Right Nav Button
        let searchButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let size: CGFloat = 21
            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.imageView?.contentMode = .scaleAspectFit
            bt.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
            return bt
        }()
        
        let categoryButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let size: CGFloat = 21
            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.imageView?.contentMode = .scaleAspectFit
            bt.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
            return bt
        }()
        
        let bellButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "bell"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            let size: CGFloat = 21
            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.imageView?.contentMode = .scaleAspectFit
            bt.addTarget(self, action: #selector(bellClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStackView = UIStackView.init(arrangedSubviews: [searchButton, categoryButton, bellButton])
        rightStackView.stackViewConfig(rightStackView)
        rightStackView.spacing = 18
        
        let rightSection = UIBarButtonItem(customView: rightStackView)
        navitem.rightBarButtonItem = rightSection
        
        locationButton.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
        locationArrowButton.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
        
        let leftStackView = UIStackView.init(arrangedSubviews: [locationButton,locationArrowButton])
        leftStackView.stackViewConfig(leftStackView)
        
        leftStackView.isLayoutMarginsRelativeArrangement = true
        leftStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.view.frame.width / 3)
        leftStackView.spacing = 5
        
        let leftSection: UIBarButtonItem = {
            let barButton = UIBarButtonItem()
            barButton.customView = leftStackView
            return barButton
        }()
        
        navitem.leftBarButtonItem = leftSection
    }

    /// For UIButton PopOver Action
    func presentOptionsPopOver(withOptionItems items: [[LocationOptionItem]], fromButtonItem ButtonItem: UIButton) {
        let optionItemListVC = LocationOptionViewController()
        optionItemListVC.items = items
        
        /// 지역 선택 위임
        optionItemListVC.selectedDelegate = self
        
        guard let popOverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Modal Presentation Style을 설정하세요!")}
        popOverPresentationController.barButtonItem = UIBarButtonItem(customView: ButtonItem)
        popOverPresentationController.delegate = self

        self.present(optionItemListVC, animated: true, completion: nil)
    }
    
    /// Pop OverList
    
    var LocationList = [LocationOptionItem]()
    
    func addLocationList() {
        var firstLocation = SetLocationOptionItem(text: "중앙동", font: UIFont(name: "Helvetica", size: 13)!, isSelected: true, setType: .myLocation)
        var secondLocation = SetLocationOptionItem(text: "정자1동", font: UIFont(name: "Helvetica", size: 13)!, isSelected: false, setType: .myLocation)
        var setLocation = SetLocationOptionItem(text: "내 동네 설정하기", font: UIFont(name: "Helvetica", size: 13)!, isSelected: false, setType: .setLocation)

        LocationList.append(contentsOf: [firstLocation, secondLocation, setLocation])
        print("loc  \(LocationList)")
    }
    
    @objc func locationItemClicked(_ sender: UIButton) {
        presentOptionsPopOver(withOptionItems: [LocationList], fromButtonItem: sender)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.locationArrowButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            self.view.layoutIfNeeded()
        }
        self.hometable.reloadData()
    }
    
    
    @objc func searchClicked() {
        print("검색!")
    }
    
    @objc func categoryClicked() {
        print("카테고리!")
        let vc = CategoryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bellClicked() {
        print("알림!")
    }
    
    let toastText: UIButton = {
        let bt = UIButton()
        bt.setTitle("토스트 텍스트 테스트", for: .normal)
        bt.contentHorizontalAlignment = .left
        let size: CGFloat = 15
        bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        bt.layer.masksToBounds = false
        bt.layer.cornerRadius = 5 // bt.frame.height / 2
        bt.clipsToBounds = true
        bt.backgroundColor = UIColor(named: CustomColor.text.rawValue)
        bt.setTitleColor(UIColor(named: CustomColor.background.rawValue), for: .normal)
        bt.frame.size = CGSize(width: UIScreen.main.bounds.width - 20, height: 30)
        return bt
    }()
    
    func setToast() {
        self.toastText.isHidden = true
        self.toastText.alpha = 1
        self.view.addSubview(toastText)
        
        toastText.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func viewToast() {
        UIView.animate(withDuration: 4) {
            self.toastText.alpha = 0
            self.toastText.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.toastText.alpha = 1
            self.toastText.isHidden = true
        }
    

    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.selectionStyle = .none
        
        let data = prodData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        
        cell.titleLabel.text = data.prodTitle
        /// Firebase Storage - image load가 너무 느림
//        fetchImage(imgView: cell.thumbnail, name: "me")
        cell.thumbnail.image = UIImage(named: data.prodImage)
        cell.locationLabel.text = data.location
        cell.priceLabel.text = data.price
        cell.timeLabel.text = " ・ " + "\(data.uploadTime)분 전"
        
        if data.heartNum > 0 {
            cell.heartLabel.text = "\(data.heartNum)"
            cell.heartIcon.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.stackView.isHidden = false
            cell.heartView.isHidden = false
            cell.heartLabel.isHidden = false
            cell.heartIcon.isHidden = false
        } else {
            cell.heartView.isHidden = true
        }
        
        if data.chatNum > 0 {
            cell.chatLabel.text = "\(data.chatNum)"
            cell.chatIcon.setImage(UIImage(systemName: "bubble.left.and.bubble.right"), for: .normal)
            cell.stackView.isHidden = false
            cell.chatView.isHidden = false
            cell.chatIcon.isHidden = false
            cell.chatLabel.isHidden = false
        } else {
            cell.chatView.isHidden = true
        }
        
        if data.replyNum > 0 {
            cell.replyLabel.text = "\(data.replyNum)"
            cell.replyIcon.setImage(UIImage(systemName: "message"), for: .normal)
            cell.stackView.isHidden = false
            cell.replyView.isHidden = false
            cell.replyIcon.isHidden = false
            cell.replyLabel.isHidden = false
        } else {
            cell.replyView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = prodData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        let vc = ContentsViewController(items: [data])
        vc.priceLabel.text = data.price
                
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
    

}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: PopOverLocationSelectedDelegate {
    func selectedLocation(controller: LocationOptionViewController, didSelectItem name: String) {
        locationButton.setTitle(name, for: .normal)
        /// Toast Popup "동네가 '\(name)'으로 변경되었어요."
        toastText.setTitle("동네가 '\(name)'으로 변경되었어요.", for: .normal)

    }
}

extension HomeViewController {
    func fetchData() {
        print("firebase 데이터 패치중")
        self.prodData.removeAll()
        
        DispatchQueue.main.async {
            self.ref.observeSingleEvent(of: .value) { snapShot in
                if let result = snapShot.value as? [[String:Any]] {
                    result.forEach { item in
                        let data = ProdData(dictionary: item as! [String:Any])
                        self.prodData.append(data)
                    }
                    self.hometable.reloadData()
                }
                
            }
            self.hometable.setNeedsLayout()
            self.hometable.layoutIfNeeded()
        }
    }
    
    func fetchImage(imgView: UIImageView, name: String) {
        self.storage.reference(withPath: "\(name).jpeg").downloadURL { (url, error) in
            print(name, url)
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            imgView.image = image
        }
//        self.storage.reference().child("/\(name).jpeg").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
//            if let error = error {
//                print(error)
//            } else {
//                imgView.image = UIImage(data: data!)
//            }
//        }.resume()
    }
}


extension Notification.Name {
    static let rotateBack = Notification.Name("rotateBack")
    static let locationChanged = Notification.Name("locationChanged")
    static let locationChangedToast = Notification.Name("locationChangedToast")
}
