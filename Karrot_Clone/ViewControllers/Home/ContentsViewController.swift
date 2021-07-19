//
//  ContentsViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/16.
//

import UIKit
import SnapKit

class ContentsViewController: UIViewController, UIGestureRecognizerDelegate {        
    
    var images = ["당근이","당근이","당근이","당근이","당근이"]
    
    let contentTable : UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
//        tv.register(Contents_HeaderCell.self, forHeaderFooterViewReuseIdentifier: Contents_HeaderCell.identifier)
        tv.register(Contents_UserInfoCell.self, forCellReuseIdentifier: Contents_UserInfoCell.identifier)
        tv.register(Contents_MainTextCell.self, forCellReuseIdentifier: Contents_MainTextCell.identifier)
        tv.register(Contents_ReportCell.self, forCellReuseIdentifier: Contents_ReportCell.identifier)
        tv.register(Contents_SellerCell.self, forCellReuseIdentifier: Contents_SellerCell.identifier)
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    
    
//    let scrollView : UIScrollView = {
//        let sv = UIScrollView()
//        return sv
//    }()


//    let prodImage: UIImageView = {
//        let img = UIImageView()
//        img.image = UIImage(named: "당근이")
//
//        img.contentMode = .scaleAspectFit
//        return img
//    }()


    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setNavItems()
//        addScrollView()
//        setPageControl()
        print("콘텐츠 뷰 디드로드")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
        view.backgroundColor = .white
        
//        let contentsNavigationController = UINavigationController(rootViewController: ContentsViewController())
//        contentsNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        contentsNavigationController.navigationBar.isTranslucent = true
//        contentsNavigationController.navigationBar.shadowImage = UIImage()
//        
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
            //            let size: CGFloat = 10
            //            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        
            
        let leftSection = UIBarButtonItem(customView: backButton)
       
        navitem.leftBarButtonItem = leftSection
        
        // right
        let shareButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let moreButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            bt.tintColor = UIColor.white
            bt.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStack = UIStackView.init(arrangedSubviews: [shareButton,moreButton])
            
        rightStack.stackViewConfig(rightStack)
        rightStack.spacing = 15
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
    
}


extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_UserInfoCell",for: indexPath) as! Contents_UserInfoCell
            cell.selectionStyle = .none
            
            cell.idLabel.text = "정자동불주먹"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_MainTextCell",for: indexPath) as! Contents_MainTextCell
            cell.selectionStyle = .none

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_ReportCell",for: indexPath) as! Contents_ReportCell
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Contents_SellerCell",for: indexPath) as! Contents_SellerCell            
            cell.selectionStyle = .none
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
    
    // HeaderView

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 400))
                
        let headerWidth = headerView.frame.width
        let headerHeight = headerView.frame.height
                
        let pageControl = self.pageControl
        pageControl.frame = CGRect(x: 0, y: headerHeight - 30, width: headerWidth , height: 10)
        pageControl.numberOfPages = images.count
        
        let scrollView : UIScrollView = {
            let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight))
            sv.showsHorizontalScrollIndicator = false
            sv.isPagingEnabled = true
            return sv
        }()
        
        scrollView.delegate = self
                
        headerView.addSubview(scrollView)
        headerView.addSubview(pageControl)
        
        
        
        for index in 0..<images.count {
            let imageView = UIImageView()
            let xPos = headerWidth * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            // data load
            imageView.image = UIImage(named: images[index])
            scrollView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            scrollView.contentSize.width = scrollView.frame.width * CGFloat(index + 1)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension ContentsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default // Status Bar 글씨 색상 흰색
            
            self.navigationController?.navigationBar.tintColor = .darkGray
            self.navigationController?.navigationBar.barTintColor = .white
            self.navigationController?.navigationBar.setBackgroundImage(.none, for: .default)
            self.navigationController?.navigationBar.shadowImage = .none
        }
        else {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black // Status Bar 글씨 색상 검정색
            self.navigationController?.navigationBar.tintColor = UIColor(named: CustomColor.reply.rawValue)
            self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.reply.rawValue)
            naviStyle()
        }
    }
    
//    func addScrollView() {
        
//        scrollView.delegate = self
        
//        view.addSubview(scrollView)
//        view.addSubview(pageControl)
//
//        scrollView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        pageControl.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-10)
//            $0.centerX.equalToSuperview()
//        }
        
//        pageControl.numberOfPages = images.count
//
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isPagingEnabled = true
//
//        for index in 0..<images.count {
//            let imageView = UIImageView()
//            let xPos = self.view.frame.width * CGFloat(index)
//            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//            imageView.image = UIImage(named: images[index]) //?.scalePreservingAspectRatio(targetSize: CGSize(width: 390, height: 420))
//            self.scrollView.addSubview(imageView)
//            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
//
//            imageView.snp.makeConstraints {
//                $0.edges.equalToSuperview()
//            }
//            scrollView.contentSize.width = scrollView.frame.width * CGFloat(index + 1)
//            print(scrollView.bounds.width)
//        }
//    }
    private func setPageControl() {
        self.pageControl.numberOfPages = images.count
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}
