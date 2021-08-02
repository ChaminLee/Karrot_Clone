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
    /// Firebase Realtime Database / Firebase Storage 연동을 위한 세팅
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    /// 기본 ProdData
    var prodData = [ProdData]()

    /// 좌상단 현재 지역 표기
    var locationData = "지역을 선택해주세요"
        
    /// 메인 홈 Tableview
    let hometable : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
        
    /// 1. setHomeTable() :  hometable 세팅
    /// 2. setNavigationItem() : Navigationbar Item 버튼 세팅
    /// 3. addLocationList() : 선택가능한 지역 추가
    /// 4. setToast() : Toast Popup 세팅
    /// 5. NotificationCenter
    ///   - rotate : 지역 선택뷰 사라질 때 arrow 다시 원복하는 애니메이션 실행
    ///   - viewToast : Toast Popup 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeTable()
        setNavigationItem()
        addLocationList()
        setToast()
        
        /// LocationArrowButton 돌려두라는 것 수신!
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .rotateBack, object: nil)
        /// Toast Popup 실행하라는 것 수신!
        NotificationCenter.default.addObserver(self, selector: #selector(viewToast), name: .locationChangedToast, object: nil)
    }
    
    /// LocationArrowButton rotate back
    @objc func rotate() {
        UIView.animate(withDuration: 0.25) {
            self.locationArrowButton.transform = CGAffineTransform.identity
        }
    }
    
    /// 1. fetchData() : prodData에 Firebase 데이터 패치
    /// 2. tabbarController 사라지지 않도록 (다른 뷰컨트롤러 영향으로)
    /// 3. navStyle() : Navigationcontroller 기본 세팅
    /// 4. UIApplication.shared.windows.last!.isHidden : 글쓰기 추가 버튼 윈도우에서 보이도록
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
    
    /// ---------- ViewDidLoad Method ----------
    func setHomeTable() {
        hometable.delegate = self
        hometable.dataSource = self
        
        view.addSubview(hometable)
        
        hometable.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        /// Tableview의 RefreshControl
        hometable.refreshControl = UIRefreshControl()
        hometable.refreshControl?.tintColor = UIColor(named: CustomColor.karrot.rawValue)
        hometable.refreshControl?.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
    }
    
    /// Tableview의 RefreshControl Action
    @objc func pullRefresh(_ sender: Any) {
        print("업데이트중")
        self.hometable.reloadData()
        hometable.refreshControl?.endRefreshing()
    }
    
    /// Left Nav Button
    /// 함수 밖에서 선언한 이유는 다른 VC에서도 접근할 일이 있기 때문
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
    
    func setNavigationItem() {
        UINavigationBar.appearance().barTintColor = UIColor(named: CustomColor.background.rawValue)
        let navitem = self.navigationItem
        
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
        
        
        let rightStackView = UIStackView(arrangedSubviews: [searchButton, categoryButton, bellButton], axis: .horizontal, spacing: 18, alignment: .center, distribution: .fill)
        
        let rightSection = UIBarButtonItem(customView: rightStackView)
        navitem.rightBarButtonItem = rightSection
        
        locationButton.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
        locationArrowButton.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
        
        let leftStackView = UIStackView(arrangedSubviews: [locationButton,locationArrowButton], axis: .horizontal, spacing: 5, alignment: .center, distribution: .fill)
        
        /// [ ] LeftStackview 전체가 버튼이 되어야 함
//        leftStackView.isLayoutMarginsRelativeArrangement = true
//        leftStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.view.frame.width / 3)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(locationItemClicked(_:)))
//        leftStackView.addGestureRecognizer(tap)
//        leftStackView.isUserInteractionEnabled = true
        
        let leftSection = UIBarButtonItem(customView: leftStackView)
        navitem.leftBarButtonItem = leftSection
    }

    /// For UIButton PopOver Action
    func presentOptionsPopOver(withOptionItems items: [[LocationOptionItem]], fromButtonItem ButtonItem: UIButton) {
        let optionItemListVC = PopOverViewController()
        optionItemListVC.items = items

        /// 지역 선택 위임
        optionItemListVC.selectedDelegate = self

        guard let popOverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Modal Presentation Style을 설정하세요!")}
        popOverPresentationController.barButtonItem = UIBarButtonItem(customView: ButtonItem)
        popOverPresentationController.delegate = self

        self.present(optionItemListVC, animated: true, completion: nil)
    }
        
    var LocationList = [LocationOptionItem]()
    
    func addLocationList() {
        var firstLocation = SetLocationOptionItem(text: "중앙동", font: UIFont(name: "Helvetica", size: 13)!, isSelected: true, setType: .myLocation)
        var secondLocation = SetLocationOptionItem(text: "정자1동", font: UIFont(name: "Helvetica", size: 13)!, isSelected: false, setType: .myLocation)
        var setLocation = SetLocationOptionItem(text: "내 동네 설정하기", font: UIFont(name: "Helvetica", size: 13)!, isSelected: false, setType: .setLocation)

        LocationList.append(contentsOf: [firstLocation, secondLocation, setLocation])
    }
    
    @objc func locationItemClicked(_ sender: UIButton) {
        presentOptionsPopOver(withOptionItems: [LocationList], fromButtonItem: sender)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                /// 180도 회전
                self.locationArrowButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            /// layoutsubviews 즉시 바로 실행 (동기)
            /// 애니메이션이기에 즉각 반영이 필요함! (setNeedLayout은 비동기적으로 실행되서 update cycle이 되서야 실행됨)
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
        bt.contentHorizontalAlignment = .left
        let size: CGFloat = 15
        bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        bt.layer.masksToBounds = false
        bt.layer.cornerRadius = 5
        bt.clipsToBounds = true
        bt.backgroundColor = UIColor(named: CustomColor.text.rawValue)
        bt.setTitleColor(UIColor(named: CustomColor.background.rawValue), for: .normal)
        bt.frame.size = CGSize(width: UIScreen.main.bounds.width - 20, height: 30)
        return bt
    }()
    
    func setToast() {
        // 처음엔 숨겨둠
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
        /// 천천히 보여지고
        UIView.animate(withDuration: 4) {
            self.toastText.alpha = 0
            self.toastText.isHidden = false
        }
        
        /// 사라지도록
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.toastText.alpha = 1
            self.toastText.isHidden = true
        }
    }
}

/// ---------- TableView Setting ----------
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
        
        /// upload 시간 기준으로 오름차순 정렬
        let data = prodData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        
        cell.titleLabel.text = data.prodTitle
        /// Firebase Storage - image load가 너무 느림
//        fetchImage(imgView: cell.thumbnail, name: "me")
        cell.thumbnail.image = UIImage(named: data.prodImage)
        cell.locationLabel.text = data.location
        cell.priceLabel.text = data.price
        
        /// [ ] 시간 케이스별 정리 필요  ( ~ 일 전, ~ 시간 전, ~ 분 전, + 끌올)
        cell.timeLabel.text = " ・ " + "\(data.uploadTime)분 전"
        
        /// 개수에 따라 초기화 or 데이터 할당
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
        /// 선택된 데이터 1개 넘겨줌
        let data = prodData.sorted(by: {$0.uploadTime < $1.uploadTime})[indexPath.row]
        let vc = ContentsViewController(items: [data])
        /// 하단 뷰에 들어갈 가격 데이터 전달
        vc.priceLabel.text = data.price
                
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /// 우선은 사이즈 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}

/// ---------- PopOver ----------
extension HomeViewController: UIPopoverPresentationControllerDelegate {
    /// presentation style 지정
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        /// LocationViewController에서 지정한대로 present 될 수 있도록 .none으로 세팅
        return .none
    }
}

/// ---------- LocationViewController의 Protocol ----------
extension HomeViewController: PopOverLocationSelectedDelegate {
    func selectedLocation(controller: PopOverViewController, didSelectItem name: String) {
        /// location 선택시 텍스트 변경
        locationButton.setTitle(name, for: .normal)
        /// Toast Popup 메시지 세팅
        toastText.setTitle("동네가 '\(name)'으로 변경되었어요.", for: .normal)
    }
}

extension HomeViewController {
    /// ---------- ViewWillAppear Method ----------
    private func fetchData() {
        self.prodData.removeAll()
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.ref.observeSingleEvent(of: .value) { snapShot in
                if let result = snapShot.value as? [[String:Any]] {
                    result.forEach { item in
                        let data = ProdData(dictionary: item as! [String:Any])
                        self.prodData.append(data)
                    }
                    self.hometable.reloadData()
                }
                
            }
        }
    }
    
    private func fetchImage(imgView: UIImageView, name: String) {
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
    
    private func navStyle() {
        /// LightMode : black  \ DarkMode : white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        /// navigationbar bar background color
        self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.background.rawValue)
        /// translucent on/off
        self.navigationController?.navigationBar.isTranslucent = false
        /// navigation separatorline 보여주기 : 모두 nil로
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}

