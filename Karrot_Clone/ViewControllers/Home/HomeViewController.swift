//
//  HomeViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit
import SnapKit
import AudioToolbox

class HomeViewController: UIViewController {
    
    var feedBackGenerator: UINotificationFeedbackGenerator?
    
    let hometable : UITableView = {
        let tv = UITableView(frame:CGRect.zero, style: .plain)
        tv.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        tv.separatorColor = UIColor(named: CustomColor.separator.rawValue)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return tv
    }()
    var usedStackView = UIStackView()
    var neighborStackView = UIStackView()
    var floatingStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeTable()
        setNavMenu()
        setFloatingButton()
        hideViewWhenTappedAround()
        setUpGenerator()
        print("뷰디드롣드")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: CustomColor.background.rawValue)
        self.navigationController?.navigationBar.isTranslucent = false
        print("뷰윌어피어")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hometable.frame = view.bounds
    }
    
    private func setUpGenerator() {
        self.feedBackGenerator = UINotificationFeedbackGenerator()
        self.feedBackGenerator?.prepare()
    }
    
    func setHomeTable() {
        hometable.delegate = self
        hometable.dataSource = self
        
        view.addSubview(hometable)
        
        hometable.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        hometable.refreshControl = UIRefreshControl()
        hometable.refreshControl?.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
    }
    
    @objc func pullRefresh(_ sender: Any) {
        print("업데이트중")
        self.hometable.reloadData()
        hometable.refreshControl?.endRefreshing()
    }
    
    func setNavMenu() {
        UINavigationBar.appearance().barTintColor = UIColor(named: CustomColor.background.rawValue)
                
        // left
        let locationButton : UIButton = {
            let bt = UIButton()
            bt.setTitle("정자1동", for: .normal)
            bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
            bt.setTitleColor(UIColor(named: CustomColor.text.rawValue), for: .normal)
            bt.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
            return bt
        }()
        
        let locationArrowButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//            let size: CGFloat = 10
//            bt.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(locationItemClicked), for: .touchUpInside)
            return bt
        }()
        
        let leftStackView = UIStackView.init(arrangedSubviews: [locationButton,locationArrowButton])
        stackViewConfig(leftStackView)
        leftStackView.spacing = 10
        
        let navitem = self.navigationItem
            
        let leftSection = UIBarButtonItem(customView: leftStackView)
       
        navitem.leftBarButtonItem = leftSection
        
        // right
        let searchButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
            return bt
        }()
        
        let categoryButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(categoryClicked), for: .touchUpInside)
            return bt
        }()
        
        let bellButton : UIButton = {
            let bt = UIButton()
            bt.setImage(UIImage(systemName: "bell"), for: .normal)
            bt.tintColor = UIColor(named: CustomColor.text.rawValue)
            bt.addTarget(self, action: #selector(bellClicked), for: .touchUpInside)
            return bt
        }()
        
        let rightStackView = UIStackView.init(arrangedSubviews: [searchButton, categoryButton, bellButton])
        stackViewConfig(rightStackView)
        rightStackView.spacing = 18
        
        let rightSection = UIBarButtonItem(customView: rightStackView)
        navitem.rightBarButtonItem = rightSection
    }
    
    func stackViewConfig(_ stackview: UIStackView) {
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
    }

    @objc func locationItemClicked() {
        print("정자 1동!")
    }
    
    @objc func searchClicked() {
        print("검색!")
    }
    
    @objc func categoryClicked() {
        print("카테고리!")
    }
    
    @objc func bellClicked() {
        print("알림!")
    }
    
    let addPostButton: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 60
        bt.setImage(UIImage(named: "Add")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        bt.addTarget(self, action: #selector(floatingButtonClicked(_:)), for: .touchUpInside)
        return bt
    }()
    
    let usedLabel: UILabel = {
        let lb = UILabel()
        lb.text = "중고거래"
        lb.textColor = .white
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        return lb
    }()
    
    let usedButton: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 40
        bt.setImage(UIImage(named: "write")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        return bt
    }()
    
    let neighborLabel: UILabel = {
        let lb = UILabel()
        lb.text = "동네홍보"
        lb.textColor = .white
        lb.font = UIFont(name: "Helvetica-Bold", size: 17)
        return lb
    }()
    
    let neighborButton: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 40
        bt.setImage(UIImage(named: "neighbor")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        return bt
    }()
    
    /// Floating Writte Button
    func setFloatingButton() {
        self.usedStackView = UIStackView.init(arrangedSubviews: [usedLabel, usedButton])
        usedStackView.axis = .horizontal
        usedStackView.spacing = 10
        usedStackView.isLayoutMarginsRelativeArrangement = true
        usedStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.usedStackView.isHidden = true
        
        self.neighborStackView = UIStackView.init(arrangedSubviews: [neighborLabel, neighborButton])
        neighborStackView.axis = .horizontal
        neighborStackView.spacing = 10
        neighborStackView.isLayoutMarginsRelativeArrangement = true
        neighborStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.neighborStackView.isHidden = true
        
        self.floatingStackView = UIStackView.init(arrangedSubviews: [neighborStackView, usedStackView, addPostButton])
        floatingStackView.distribution = .equalSpacing
        floatingStackView.spacing = 15
        floatingStackView.axis = .vertical
        floatingStackView.alignment = .trailing
        
        view.insertSubview(floatingStackView, at: 1)
        view.bringSubviewToFront(floatingStackView)
        
        floatingStackView.snp.makeConstraints {
//            $0.bottom.equalToSuperview().inset(15)
//            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(additionalSafeAreaInsets.bottom).inset(15)
            $0.right.equalTo(additionalSafeAreaInsets.right).inset(20)
        }
    }
    
    lazy var floatingDimView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true

        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        
        return view
    }()
    
    var isShowFloating: Bool = false
    
    lazy var buttons = [usedStackView, neighborStackView]
    
    @objc func floatingButtonClicked(_ sender: UIButton) {
        let imgSize: CGFloat = 60
                
        if isShowFloating {
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.floatingDimView.alpha = 0
            }) { (_) in
                self.floatingDimView.isHidden = true
            }
        } else {
//            AudioServicesPlaySystemSound(4095)
            self.feedBackGenerator?.notificationOccurred(.success)
            
            self.floatingDimView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.floatingDimView.alpha = 1
            }
            
            buttons.forEach { [weak self] stack in
                UIView.animate(withDuration: 0.3) {
                    stack.isHidden = false
                    self?.view.layoutIfNeeded()
                }
                
            }
        }
        self.isShowFloating = !isShowFloating
        
        print("clicked \(isShowFloating)")
        
        let image = isShowFloating ? UIImage(named: "cancel") : UIImage(named: "Add")
        let rotation = isShowFloating ? CGAffineTransform(rotationAngle: .pi - (.pi / 2)) : CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            sender.setImage(image?.scalePreservingAspectRatio(targetSize: CGSize(width: imgSize, height: imgSize)), for: .normal)
            sender.transform = rotation
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = "캐논 g7x mark3 풀박스 2020년 10월 구입 제품 팔아요 캐논 g7x mark3 풀박스"
        cell.thumbnail.image = UIImage(named: "당근이")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContentsViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
//        DispatchQueue.main.async {
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150.0)
    }
}

extension UIStackView {
    func stackViewConfig(_ stackview: UIStackView) {
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
    }
}

extension HomeViewController {
    func hideViewWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissView))
        tap.cancelsTouchesInView = false
        self.floatingDimView.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        let imgSize: CGFloat = 60
        
        buttons.map {$0.isHidden = true}
        self.floatingDimView.alpha = 0
    
        self.floatingDimView.isHidden = true
        
        let image = UIImage(named: "Add")
        let rotation = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            self.addPostButton.setImage(image?.scalePreservingAspectRatio(targetSize: CGSize(width: imgSize, height: imgSize)), for: .normal)
            self.addPostButton.transform = rotation
        }
        isShowFloating = !isShowFloating
        print("배경 \(isShowFloating)")
    }
}
