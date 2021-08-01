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
    
    let ref = Database.database().reference()
    var ContentsData = [ProdData]()
    
    init(items: [ProdData]) {
        self.ContentsData = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var images = ["당근이","당근이2","당근이3","당근이4","당근이5"]
    
    let bottomAnchor: UIView = {
        let ba = UIView()
        ba.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        return ba
    }()
        
    
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
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        
        return pc
    }()
    
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        return sv
    }()
    
    let statusBarView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height)) // view.frame.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottttomAnchorConfig()
        config()
        setNavItems()
        naviStyle()
        setStatusbar()
    }
    
    func setStatusbar() {
        statusBarView.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        statusBarView.alpha = 0
        view.addSubview(statusBarView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.async {
            self.contentTable.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func naviStyle(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        
        // 네비 바 전체 Backgrond 이미지, 경계선 삭제
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTable.frame = view.bounds
        contentTable.reloadData()
    }
    
    let heartButton: UIButton = {
        let bt = UIButton()
        bt.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let size: CGFloat = 23
        bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.tintColor = UIColor(named: CustomColor.badge.rawValue)
        bt.setImage(UIImage(systemName: "heart"), for: .normal)
        bt.addTarget(self, action: #selector(heartClicked), for: .touchUpInside)
        return bt
    }()
    
    var heartStatus = false
    
    @objc func heartClicked() {
        if !heartStatus {
            heartButton.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.tintColor = UIColor(named: CustomColor.badge.rawValue)
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        heartStatus = !heartStatus
    }
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: CustomColor.separator.rawValue)
        return view
    }()
    
    let priceLabel: UILabel = {
        let lb = UILabel()
        lb.text = "17,000원"
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        return lb
    }()
    
    let negoButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("가격제안불가", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.badge.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
        return bt
    }()
    
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
    
    func bottttomAnchorConfig() {
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
        contentTable.estimatedRowHeight = 100
        contentTable.rowHeight = UITableView.automaticDimension
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
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
            $0.bottom.equalTo(bottomAnchor.snp.top)
        }
    
    }
    
    func setNavItems() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let navitem = self.navigationItem
        
        // left
        let backButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let leftSection = UIBarButtonItem(customView: backButton)
       
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
    
    func presentOptionsPopOver(withOptionItems mannerItems : [[MannerDetailnfo]], fromButtonItem ButtonItem: UIButton) {
        let optionItemListVC = LocationOptionViewController()
        optionItemListVC.manners = mannerItems
        optionItemListVC.view.backgroundColor = UIColor(named: CustomColor.karrot.rawValue)
        optionItemListVC.preferredContentSize = CGSize(width: 230, height: 90)
        
        
        guard let popOverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Modal Presentation Style을 설정하세요!")}
        popOverPresentationController.barButtonItem = UIBarButtonItem(customView: ButtonItem)
        popOverPresentationController.permittedArrowDirections = .up
        popoverPresentationController?.popoverLayoutMargins = UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0)
        popOverPresentationController.delegate = self
        self.present(optionItemListVC, animated: true, completion: nil)
    }
}


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
            
            let img: UIImageView = {
                let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                img.image = UIImage(named: data.userIcon)?.scalePreservingAspectRatio(targetSize: CGSize(width: 45, height: 45))
                img.layer.masksToBounds = false
                img.layer.cornerRadius = img.frame.width / 2
                img.clipsToBounds = true
                    
                return img
            }()
            
            cell.profileImage.image = img.image
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
            
            cell.buttonAction = { [unowned self] in
                print("매너 설명 소환")
           
                let label : UILabel = {
                    let lb = UILabel()
                    lb.text = " "
                    lb.textColor = .white
                    lb.numberOfLines = 0
                    return lb
                }()
                let manner = SetMannerDetailInfo(label: label, font: UIFont(name: "Helvetica", size: 13)!)
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
            let attr: [NSAttributedString.Key:Any] = [
                .font: UIFont(name: "Helvetica", size: 12),
                .foregroundColor: UIColor(named: CustomColor.reply.rawValue),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]

            let attrStr = NSMutableAttributedString(string: data.category,attributes: attr)
            cell.categoryButton.setAttributedTitle(attrStr, for: .normal)
            
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
            /// unowned로 설정 ( 값이 있음을 가정, 옵셔널일 경우 weak으로 해야하지만
            /// ViewController가 여전히 메모리에 있음을 가정하고 진행
            cell.reportButtonAction = { [unowned self] in
                /// 신고 페이지로 이동 필요
                print("신고")
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_SellerCell",for: indexPath) as! Contents_SellerCell            
            cell.selectionStyle = .none
            
            cell.titleLabel.text = "\(data.userID)님의 판매 상품"
            cell.userID = data.userID
            
        
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_RecommendCell",for: indexPath) as! Contents_RecommendCell
            cell.selectionStyle = .none
            
            cell.titleLabel.text = "차밍님, 이건 어때요?"
//            cell.backgroundColor = UIColor(named: CustomColor.background.rawValue)
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
    
    
    // HeaderView 이미지 스크롤

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 390))

        let headerWidth = headerView.frame.width
        let headerHeight = headerView.frame.height

        // 페이지 컨트롤
        let pageControl = self.pageControl
        pageControl.frame = CGRect(x: 0, y: headerHeight - 30, width: headerWidth , height: 10)
        pageControl.numberOfPages = images.count

        // 스크롤 뷰
        let scrollView = self.scrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)

        scrollView.delegate = self

        headerView.addSubview(scrollView)
        headerView.addSubview(pageControl)


        for index in 0..<images.count {
            let imageView = UIImageView()
            imageView.layer.masksToBounds = false
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOffset = CGSize(width: 0, height: -10)
            imageView.layer.shadowRadius = 2
            imageView.layer.shadowOpacity = 0.25
            imageView.clipsToBounds = true

            let xPos = headerWidth * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = UIImage(named: images[index])
            scrollView.addSubview(imageView)

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }

        scrollView.contentSize.width = scrollView.frame.width * CGFloat(images.count)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 390
    }
    
}

extension ContentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Stretch 확인
            
            
        /// navigation bar color 변경
        if scrollView.contentOffset.y > 300 {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default // Status Bar 글씨 색상 흰색
            self.navigationController?.navigationBar.backgroundColor = UIColor(named: CustomColor.background.rawValue)
            self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.text.rawValue)
            self.statusBarView.alpha = 1
            self.navigationController?.navigationBar.shadowImage = .none
        }
        else {
//            self.navigationController?.navigationBar.barStyle = UIBarStyle.black // Status Bar 글씨 색상 검정색
            self.statusBarView.alpha = 0
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.naviStyle()
            
        }
        
    }
    
    private func setPageControl() {
        self.pageControl.numberOfPages = images.count
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        self.pageControl.currentPage = currentPage
        print("현재페이지 :\(currentPage)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value = self.scrollView.contentOffset.x/self.scrollView.frame.size.width
        self.setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension ContentsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ContentsViewController: ContentsMainTextDelegate {
    func categoryButtonTapped() {
        // ToDo - 해당 카테고리 이동
        let vc = CategoryProdViewController()
        let data = ContentsData[0]
        
        vc.categoryTitle = data.category
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
