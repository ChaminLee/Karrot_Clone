//
//  HomeViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit
import SnapKit
import Foundation

class HomeViewController: UIViewController {
    
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
        print("디드")
        setSampleData()
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
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        navStyle()
        UIApplication.shared.windows.last!.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    // left
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
        
        // right
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
        
        // 지역 선택 위임
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
        
        let data = prodData[indexPath.row]
        
        cell.titleLabel.text = data.prodTitle
        cell.thumbnail.image = UIImage(named: data.prodImage)
        cell.locationLabel.text = data.location
        cell.priceLabel.text = data.price
        cell.timeLabel.text = " ・ " + data.uploadTime
        
        if data.heartNum > 0 {
            cell.heartLabel.text = "\(data.heartNum)"
            cell.heartIcon.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.stackView.isHidden = false
            cell.heartView.isHidden = false
            cell.heartLabel.isHidden = false
            cell.heartIcon.isHidden = false
        }
        
        if data.chatNum > 0 {
            cell.chatLabel.text = "\(data.chatNum)"
            cell.chatIcon.setImage(UIImage(systemName: "bubble.left.and.bubble.right"), for: .normal)
            cell.stackView.isHidden = false
            cell.chatView.isHidden = false
            cell.chatIcon.isHidden = false
            cell.chatLabel.isHidden = false
        }
        
        if data.replyNum > 0 {
            cell.replyLabel.text = "\(data.replyNum)"
            cell.replyIcon.setImage(UIImage(systemName: "message"), for: .normal)
            cell.stackView.isHidden = false
            cell.replyView.isHidden = false
            cell.replyIcon.isHidden = false
            cell.replyLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = prodData[indexPath.row]
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
        toastText.setTitle("동네가 '\(name)'으로 변경되었어요.", for: .normal)
        
        // snackbar "동네가 '\(name)'으로 변경되었어요."
        showToast(controller: self, message: "동네가 '\(name)'으로 변경되었어요.", seconds: 3)
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black //UIColor(named: CustomColor.badge.rawValue)
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
        
    }
    
}

extension HomeViewController {
    func setSampleData() {
        prodData.append(contentsOf: [
            ProdData(prodImage: "당근이", prodTitle: "당근이 팝니다", location: "행운동", uploadTime: "1분 전", price: "50,000원", visitNum: 0, heartNum: 20, chatNum: 30, replyNum: 5, mannerDegree: 45.1, category: "인기매물", prodDescription: "당근이 한 번 밖에 안썼습니다. ", userID: "중앙동불주먹", userIcon: "당근이"),
            ProdData(prodImage: "당근이2", prodTitle: "당근이2 팝니다", location: "중앙동", uploadTime: "5분 전", price: "150,000원", visitNum: 15, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동메시", userIcon: "당근이2"),
            ProdData(prodImage: "당근이4", prodTitle: "당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...", location: "봉천2동", uploadTime: "10분 전", price: "70,000원", visitNum: 50, heartNum: 40, chatNum: 30, replyNum: 2, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근이 팝니다. 이 당근이는 사연이 있어서 파는 물건이니 부디 잘 다뤄주세요...당근이를 아껴주시고 사랑해주세요! 바니바니 당근당근", userID: "중앙동메시", userIcon: "당근이2"),
            ProdData(prodImage: "당근이6", prodTitle: "당근이2 팝니다", location: "행운동", uploadTime: "15분 전", price: "5,000원", visitNum: 25, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 70.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "봉천동메시", userIcon: "당근이5"),
            ProdData(prodImage: "당근이5", prodTitle: "당근이2 팝니다", location: "중앙동", uploadTime: "20분 전", price: "5,300원", visitNum: 55, heartNum: 20, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동카카", userIcon: "당근이6"),
            ProdData(prodImage: "당근이7", prodTitle: "당근이2 팝니다", location: "봉천2동", uploadTime: "1분 전", price: "545,000원", visitNum: 512, heartNum: 0, chatNum: 30, replyNum: 0, mannerDegree: 30.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동루카쿠", userIcon: "당근이2"),
            ProdData(prodImage: "당근이6", prodTitle: "당근이2 팝니다", location: "중앙동", uploadTime: "4분 전", price: "50,300원", visitNum: 90, heartNum: 2, chatNum: 0, replyNum: 0, mannerDegree: 37.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동벤테케", userIcon: "당근이7"),
            ProdData(prodImage: "당근이2", prodTitle: "당근이2 팝니다", location: "봉천동", uploadTime: "50분 전", price: "50,220원", visitNum: 87, heartNum: 20, chatNum: 30, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동손흥민", userIcon: "당근이2"),
            ProdData(prodImage: "당근이3", prodTitle: "당근이2 팝니다", location: "행운동", uploadTime: "43분 전", price: "22,000원", visitNum: 25, heartNum: 0, chatNum: 3, replyNum: 1, mannerDegree: 38.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동날라차기", userIcon: "당근이4"),
            ProdData(prodImage: "당근이7", prodTitle: "당근이2 팝니다", location: "중앙2동", uploadTime: "41분 전", price: "15,000원", visitNum: 35, heartNum: 200, chatNum: 30, replyNum: 0, mannerDegree: 44.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "아이디랜덤", userIcon: "당근이"),
            ProdData(prodImage: "당근이6", prodTitle: "스페셜 당근이 팝니다", location: "중앙동", uploadTime: "34분 전", price: "32,000원", visitNum: 45, heartNum: 20, chatNum: 3, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동거래왕", userIcon: "당근이2"),
            ProdData(prodImage: "당근이2", prodTitle: "귀여운 당근이 팝니다", location: "행운동", uploadTime: "54분 전", price: "54,000원", visitNum: 115, heartNum: 2000, chatNum: 30, replyNum: 30, mannerDegree: 66.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "중앙동당근이", userIcon: "당근이5"),
            ProdData(prodImage: "당근이", prodTitle: "당근이2 팝니다", location: "봉천동", uploadTime: "14분 전", price: "52,000원", visitNum: 25, heartNum: 1, chatNum: 5, replyNum: 0, mannerDegree: 50.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 ", userID: "당근짱짱최고", userIcon: "당근이7"),
            ProdData(prodImage: "당근이3", prodTitle: "당근이2 팝니다", location: "중앙2동", uploadTime: "44분 전", price: "550,000원", visitNum: 0, heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 36.5, category: "유아동", prodDescription: "당근이 한 번 밖에 안썼습니다. 유아용으로 판매합니다. 지금 사시면 무려 공짜! 오셔서 가져가세요 당근마켓은 대한민국의 중고 거래, 소상공인 홍보 등 생활정보 소프트웨어이다. 중고거래, 지역업체, 질문답변, 부동산, 구인구직 등 지역 내에서 발생하는 생활정보를 검색하고 게시자와 실시간으로 채팅할 수 있다", userID: "바니바니당근당근", userIcon: "당근이3"),
        ])
    }
}

extension Notification.Name {
    static let rotateBack = Notification.Name("rotateBack")
    static let locationChanged = Notification.Name("locationChanged")
    static let locationChangedToast = Notification.Name("locationChangedToast")
}
