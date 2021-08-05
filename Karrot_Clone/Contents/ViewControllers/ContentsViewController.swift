//
//  ContentsViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit
import Firebase

class ContentsViewController: UIViewController, UIGestureRecognizerDelegate {        
    
    /// Firebase Realtime Database 세팅
    let ref = Database.database().reference()
    var ContentsData = [ProdData]()
    
    /// 데이터 초기 세팅
    init(items: [ProdData]) {
        self.ContentsData = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 최하단 앵커바
    let bottomAnchor: UIView = {
        let ba = UIView()
        ba.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        return ba
    }()
        
    /// 메인 상품 테이블
    let contentTable : UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.register(Contents_UserInfoCell.self, forCellReuseIdentifier: Contents_UserInfoCell.identifier)
        tv.register(Contents_MainTextCell.self, forCellReuseIdentifier: Contents_MainTextCell.identifier)
        tv.register(Contents_ReportCell.self, forCellReuseIdentifier: Contents_ReportCell.identifier)
        tv.register(Contents_SellerCell.self, forCellReuseIdentifier: Contents_SellerCell.identifier)
        tv.register(Contents_RecommendCell.self, forCellReuseIdentifier: Contents_RecommendCell.identifier)
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tv.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        /// contentInset은 조정되지 않음
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    /// 이미지 슬라이더 내 페이지 컨트롤
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        
        return pc
    }()
    
    /// 이미지 슬라이더 이미지 스크롤 뷰
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .blue
        sv.isPagingEnabled = true
        return sv
    }()
    
    
    /// Statusbar
    let statusBarView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height)) // view.frame.size.width
    
    /// 1. bottttomAnchorConfig() : 최하단 뷰 구성 세팅
    /// 2. config() : 기본 세팅 (테이블뷰, 최하단뷰)
    /// 3. setNavigationItems() : NavigationItem 세팅
    /// 4. naviStyle() : 기본 Navigationcontroller 세팅 (색, 투명도)
    /// 5. setStatusbar() : Statusbar 기본 세팅
    override func viewDidLoad() {
        super.viewDidLoad()
        bottttomAnchorConfig()
        config()
        setNavigationItems()
        naviStyle()
        setStatusbar()
    }
    
    func setStatusbar() {
        statusBarView.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        statusBarView.alpha = 0
        view.addSubview(statusBarView)
    }
    
    /// 1. setNavigationColorByHeight() : Navigationcontroller 초기 세팅 ( by offset.y)
    /// 2. tabbarcontroller : 해당 뷰에서는 숨기기
    /// 3. 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationColorByHeight(contentTable)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.async {
            self.contentTable.reloadData()
        }
    }
    
    /// 상단 그라데이션 레이어
    let gradient: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.locations = [0.0,1.0]
        gl.colors = [UIColor.lightGray.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        return gl
    }()
    
    func setNavigationColorByHeight(_ sender: UITableView) {
        /// navigation bar color 변경
        if sender.contentOffset.y > 300 {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default // Status Bar 글씨 색상 흰색
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: CustomColor.background.rawValue)
            self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.text.rawValue)
            self.statusBarView.alpha = 1
            self.navigationController?.navigationBar.shadowImage = .none
        }
        else {
            /// 우선 투명하게 만들고
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.clear
            
            /// gradient frame 설정
            gradient.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height)
            /// layer에 추가
            self.view.layer.addSublayer(gradient)
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    func naviStyle(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        // 네비 바 전체 Backgrond 이미지, 경계선 삭제
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /// 최하단뷰 - 하트 뷰
    let heartButton: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let size: CGFloat = 23
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.tintColor = UIColor(named: CustomColor.reply.rawValue)
        bt.setImage(UIImage(systemName: "heart"), for: .normal)
        bt.addTarget(self, action: #selector(heartClicked), for: .touchUpInside)
        return bt
    }()
    
    var heartStatus = false
    
    @objc func heartClicked() {
        if !heartStatus {
            /// customColor.karrot 보다 조금 더 진하게
            heartButton.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.tintColor = UIColor(named: CustomColor.reply.rawValue)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        heartStatus = !heartStatus
    }
    
    /// 최하단뷰 - 구분선
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CustomColor.separator.rawValue)
        return view
    }()
    
    /// 최하단뷰 - 가격
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "17,000원"
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        return lb
    }()
    
    /// 최하단뷰 - 네고 버튼
    let negoButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("가격제안불가", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.badge.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        return bt
    }()
    
    /// 최하단뷰 - 거래하기
    let chatTrade: UIButton = {
        let bt = UIButton()
        bt.setTitle("채팅으로 거래하기", for: .normal)
        let size: CGFloat = 5
        bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
        bt.layer.masksToBounds = false
        bt.layer.cornerRadius = 5 // bt.frame.height / 2
        bt.clipsToBounds = true
        bt.backgroundColor = UIColor(named: CustomColor.karrot.rawValue)
        return bt
    }()
    
    /// 최하단뷰 구성요소 세팅
    func bottttomAnchorConfig() {
        /// 가격제안여부 버튼 반영
        if ContentsData[0].nego {
            let attr = negoButton.addBottomLine(font: UIFont(name: "Helvetica", size: 14)!, color: UIColor(named: CustomColor.karrot.rawValue)!, string: "가격제안하기")
            negoButton.setAttributedTitle(attr, for: .normal)
            negoButton.addTarget(self, action: #selector(negoAction), for: .touchUpInside)
        }
        
        [heartButton, separatorLine, priceLabel,negoButton,chatTrade].forEach { item in
            bottomAnchor.addSubview(item)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(15)
        }
        
        separatorLine.snp.makeConstraints {
            $0.leading.equalTo(heartButton.snp.trailing).offset(20)
            $0.width.equalTo(1)
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorLine.snp.trailing).offset(15)
            $0.top.equalTo(separatorLine.snp.top)
        }
        
        negoButton.snp.makeConstraints {
            $0.leading.equalTo(priceLabel.snp.leading)
            $0.bottom.equalTo(separatorLine.snp.bottom)
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
        }
        
        chatTrade.snp.makeConstraints {
            $0.centerY.equalTo(heartButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(150)
            $0.height.equalTo(separatorLine.snp.height)
        }
    }
    
    @objc func negoAction() {
        print("네고가능")
    }
    
    func config() {
        view.backgroundColor = UIColor(named: CustomColor.background.rawValue)

        /// header view
        let headerView = StretchTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 390))
        
        let slider = headerView.sliderView
        if ContentsData[0].detailImages.count > 1 {
            headerView.pageControl.numberOfPages = ContentsData[0].detailImages.count
        }

        for i in 0..<ContentsData[0].detailImages.count {
            let imageView = UIImageView()
            let xPos = slider.bounds.width * CGFloat(i)
            print("xPos: \(xPos)")
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: ContentsData[0].detailImages[i])
            imageView.frame = CGRect(x: xPos, y: 0, width: slider.bounds.width, height: slider.bounds.height)
            imageView.contentMode = .scaleAspectFill
            slider.addSubview(imageView)
        }

        slider.contentSize.width = CGFloat(ContentsData[0].detailImages.count) * slider.frame.width
        contentTable.tableHeaderView = headerView
        
        contentTable.estimatedRowHeight = 100
        contentTable.rowHeight = UITableView.automaticDimension
        
        contentTable.delegate = self
        contentTable.dataSource = self
      
        /// 최하단 separator line 지우기
        contentTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: contentTable.frame.size.width, height: 1))


        view.backgroundColor = .white

        view.addSubview(contentTable)
        view.addSubview(bottomAnchor)
        
        bottomAnchor.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(117)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentTable.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.bottom.equalTo(bottomAnchor.snp.top).inset(30)
        }
    }
    
    func setNavigationItems() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let navitem = self.navigationItem
        
        // left
        let backButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let homeButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "house"), for: .normal)
            bt.addTarget(self, action: #selector(homeButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let leftStack = UIStackView(arrangedSubviews: [backButton,homeButton], axis: .horizontal, spacing: 20, alignment: .center, distribution: .fill)
        
        let leftSection = UIBarButtonItem(customView: leftStack)
       
        navitem.leftBarButtonItem = leftSection
        
        // right
        let shareButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            bt.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let moreButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            bt.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStack = UIStackView(arrangedSubviews: [shareButton,moreButton], axis: .horizontal, spacing: 20, alignment: .center, distribution: .fill)
            
        let rightSection = UIBarButtonItem(customView: rightStack)
       
        navitem.rightBarButtonItem = rightSection
    }
    
    @objc func homeButtonClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClicked() {
        if let name = URL(string: "https://github.com/ChaminLee") {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC,animated: true,completion: nil)
        }
    }
    
    @objc func moreButtonClicked() {
        let alert = UIAlertController()
            
        alert.addAction(UIAlertAction(title: "신고하기", style: .default , handler:{ (UIAlertAction)in
            // 신고 뷰 이동
        }))
        alert.addAction(UIAlertAction(title: "이 사용자의 글 보지 않기", style: .default , handler:{ (UIAlertAction)in
            // 차단 핸들러
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ (UIAlertAction)in
            // 취소
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    /// 매너온도 클릭시 PopOver
    func presentOptionsPopOver(withOptionItems mannerItems : [[MannerItem]], fromButtonItem ButtonItem: UIButton) {
        let optionItemListVC = PopOverViewController()
        optionItemListVC.manners = mannerItems
        optionItemListVC.view.backgroundColor = UIColor(named: CustomColor.karrot.rawValue)
        optionItemListVC.preferredContentSize = CGSize(width: 230, height: 90) // popover size
        
        guard let popOverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Modal Presentation Style을 설정하세요!")}
        popOverPresentationController.barButtonItem = UIBarButtonItem(customView: ButtonItem)
        popOverPresentationController.permittedArrowDirections = .up
        popOverPresentationController.delegate = self
        self.present(optionItemListVC, animated: true, completion: nil)
    }
}

/// ---------- TableView Setting ----------
extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = ContentsData[0]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_UserInfoCell",for: indexPath) as! Contents_UserInfoCell
            
            cell.selectionStyle = .none
            
            cell.profileImage.image = UIImage(named: data.userIcon)?.scalePreservingAspectRatio(targetSize: CGSize(width: 45, height: 45))
            cell.idLabel.text = data.userID
            cell.locationLabel.text = data.location
            
            
            var color = UIColor()
            
            switch data.mannerDegree {
            case 0..<32:
                color = UIColor(named: CustomColor.manner1.rawValue)!
            case 32..<36.5:
                color = UIColor(named: CustomColor.manner2.rawValue)!
            case 36.5..<40:
                color = UIColor(named: CustomColor.manner3.rawValue)!
            case 40..<50:
                color = UIColor(named: CustomColor.manner4.rawValue)!
            case 50..<60:
                color = UIColor(named: CustomColor.manner5.rawValue)!
            case 60...100:
                color = UIColor(named: CustomColor.manner6.rawValue)!
            default:
                break
            }
            
            cell.degreeLabel.textColor = color
            cell.degreeBar.progressTintColor = color
            cell.degreeLabel.text = "\(data.mannerDegree)℃"
            cell.degreeBar.setProgress(data.mannerDegree * 0.01, animated: true)
            
            /// 매너온도 등장!
            cell.buttonAction = { [unowned self] in
                let label : UILabel = {
                    let lb = UILabel()
                    lb.text = " "
                    lb.textColor = .white
                    lb.numberOfLines = 0
                    return lb
                }()
                let manner = SetMannerDetailInfo(label: label, font: UIFont(name: "Helvetica", size: 13)!,setType: .mannerInfo)
                presentOptionsPopOver(withOptionItems: [[manner]], fromButtonItem: cell.mannerInfo)
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_MainTextCell",for: indexPath) as! Contents_MainTextCell
            
            cell.selectionStyle = .none
            cell.cellDelegate = self
            
            cell.titleLabel.text = data.prodTitle
            cell.timeLabel.text = "・ " + "\(data.uploadTime)분 전"
            
            /// category
            let attr = cell.categoryButton.addBottomLine(font: UIFont(name: "Helvetica", size: 12)!, color: UIColor(named: CustomColor.reply.rawValue)!, string: data.category)
            cell.categoryButton.setAttributedTitle(attr, for: .normal)
            
            cell.mainLabel.text = data.prodDescription
            
            if data.chatNum > 0 {
                cell.chatLabel.text = "채팅 \(data.chatNum)"
                cell.stackView.isHidden = false
                cell.chatLabel.isHidden = false
                cell.chatView.isHidden = false
            }
            
            if data.heartNum > 0 {
                cell.heartLabel.text = "관심 \(data.heartNum)"
                cell.stackView.isHidden = false
                cell.heartLabel.isHidden = false
                cell.heartView.isHidden = false
            }
            
            if data.visitNum > 0 {
                cell.visitedLabel.text = "조회 \(data.visitNum)"
                cell.stackView.isHidden = false
                cell.visitedLabel.isHidden = false
                cell.visitView.isHidden = false
                
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_ReportCell",for: indexPath) as! Contents_ReportCell
            cell.selectionStyle = .none
                        
            /// ViewController > TableView > TableViewCell > reportButtonAction 사이클(순환참조)을 막기 위해
            /// unowned로 설정 ( 값이 있음을 가정, 옵셔널일 경우 weak으로 해야하지만 ViewController가 여전히 메모리에 있음을 가정하고 진행)
            cell.reportButtonAction = { [unowned self] in
                /// 신고 페이지로 이동 필요
                print("신고")
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_SellerCell",for: indexPath) as! Contents_SellerCell            
            cell.selectionStyle = .none
            cell.userDelegate = self
            
            cell.titleLabel.text = "\(data.userID)님의 판매 상품"
            cell.userID = data.userID
                    
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_RecommendCell",for: indexPath) as! Contents_RecommendCell
            
            cell.selectionStyle = .none
            cell.recommendDelegate = self
            
            cell.titleLabel.text = "차밍님, 이건 어때요?"
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_SellerCell",for: indexPath) as! Contents_SellerCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 390
    }
    
}

extension ContentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Stretch 확인
        let offsetY = scrollView.contentOffset.y
        let headerView = self.contentTable.tableHeaderView as! StretchTableHeaderView
//        headerView.pushDownScroll(scrollView: scrollView)
        
        
        /// navigation bar color 변경
        if offsetY > 300 {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default // Status Bar 글씨 색상 흰색
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: CustomColor.background.rawValue)
            self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.text.rawValue)
            self.statusBarView.alpha = 1
            self.navigationController?.navigationBar.shadowImage = .none
            gradient.isHidden = true
        } else if offsetY < 0 {
            headerView.botttomGradient.isHidden = true
        } else {
            self.statusBarView.alpha = 0
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.naviStyle()
            gradient.isHidden = false
            headerView.botttomGradient.isHidden = false
        }
    }
}

extension ContentsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ContentsViewController: ContentsMainTextDelegate {
    func categoryButtonTapped() {
        let vc = CategoryProdViewController()
        let data = ContentsData[0]
        
        vc.categoryTitle = data.category
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/// 유저의 다른 상품 클릭시 상품뷰 이동
extension ContentsViewController: cellToPushNavDelegate {
    func pushNav(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

/// 추천 상품 클릭시 상품뷰 이동
extension ContentsViewController: recommendPushNavDelegate {
    func recommendPushNav(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
