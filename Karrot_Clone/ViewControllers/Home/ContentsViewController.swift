//
//  ContentsViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit

class ContentsViewController: UIViewController, UIGestureRecognizerDelegate {        
    
    var ContentsData = [ProdData]() //ProdData(prodImage: "", prodTitle: "", location: "", uploadTime: "", price: "", heartNum: 0, chatNum: 0, replyNum: 0, mannerDegree: 0.0, category: "", prodDescription: "", userID: "", userIcon: "")
    
    init(items: [ProdData]) {
        self.ContentsData = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var images = ["당근이","당근이2","당근이3","당근이4","당근이5"]
    
    let contentTable : UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        tv.register(Contents_UserInfoCell.self, forCellReuseIdentifier: Contents_UserInfoCell.identifier)
        tv.register(Contents_MainTextCell.self, forCellReuseIdentifier: Contents_MainTextCell.identifier)
        tv.register(Contents_ReportCell.self, forCellReuseIdentifier: Contents_ReportCell.identifier)
        tv.register(Contents_SellerCell.self, forCellReuseIdentifier: Contents_SellerCell.identifier)
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        setNavItems()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true

        naviStyle()
        print("콘텐츠 뷰 디드로드")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.backgroundColor 
        DispatchQueue.main.async {
            self.contentTable.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.background.rawValue)
        self.navigationController?.navigationBar.isTranslucent = false
        
        print("사라져")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTable.frame = view.bounds
        contentTable.reloadData()
    }
    
    func config() {
        contentTable.estimatedRowHeight = 100
        contentTable.rowHeight = UITableView.automaticDimension
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
        view.backgroundColor = .white

        view.addSubview(contentTable)
        
        contentTable.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets.top)
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
        
        let rightStack = UIStackView.init(arrangedSubviews: [shareButton,moreButton])
            
        rightStack.stackViewConfig(rightStack)
        rightStack.spacing = 20
        let rightSection = UIBarButtonItem(customView: rightStack)
       
        navitem.rightBarButtonItem = rightSection
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func shareButtonClicked() {
        print("share")
    }
    @objc func moreButtonClicked() {
        print("more")
    }
    
    func naviStyle(){
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        // 네비 바 전체 Backgrond 이미지, 경계선 삭제
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
        return 4
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
            cell.timeLabel.text = " ・ " + data.uploadTime
            cell.categoryButton.setTitle(data.category, for: .normal)
            cell.mainLabel.text = data.prodDescription
            
            if data.chatNum > 0 {
                cell.chatLabel.text = "채팅 \(data.chatNum)"
                cell.stackView.isHidden = false
                cell.chatLabel.isHidden = false
            }
            
            if data.heartNum > 0 {
                cell.heartLabel.text = "관심 \(data.heartNum)"
                cell.stackView.isHidden = false
                cell.heartLabel.isHidden = false
            }
            
            if data.visitNum > 0 {
                cell.visitedLabel.text = "조회 \(data.visitNum)"
                cell.stackView.isHidden = false
                cell.visitedLabel.isHidden = false
                
            }
            
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_ReportCell",for: indexPath) as! Contents_ReportCell
            cell.selectionStyle = .none
                        
            cell.reportButtonAction = { [unowned self] in
                print("신고")
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_SellerCell",for: indexPath) as! Contents_SellerCell            
            cell.selectionStyle = .none
            
            cell.frame = contentTable.bounds
            cell.layoutIfNeeded()
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
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 400))

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

        print("헤더 등장! \(headerView.frame)")

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
        return 400
    }
}

extension ContentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            if scrollView.contentOffset.y > 300 {

                self.navigationController?.navigationBar.barStyle = UIBarStyle.default // Status Bar 글씨 색상 흰색
    //            self.navigationController?.navigationBar.backgroundColor = .white
                self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.text.rawValue)
                self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.background.rawValue)
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.shadowImage = .none
            }
            else {
                
                self.navigationController?.navigationBar.barStyle = UIBarStyle.black // Status Bar 글씨 색상 검정색
                self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.reply.rawValue)
    //            self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.reply.rawValue)
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.backgroundColor = .clear
                self.naviStyle()
            }
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
        // ToDo
        print("DD")
        print("된당 이제")
    }
}
