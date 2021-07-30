//
//  FloatingViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/26.
//

import UIKit
import SnapKit
import AudioToolbox

class FloatingButtonController: UIViewController {

    var AddButton: UIButton!
    
    var usedStackView = UIStackView()
    var neighborStackView = UIStackView()
    var floatingStackView = UIStackView()
    
    var feedBackGenerator: UINotificationFeedbackGenerator?
    
    private func setUpGenerator() {
        self.feedBackGenerator = UINotificationFeedbackGenerator()
        self.feedBackGenerator?.prepare()
    }
    
    let usedTitle: UIButton = {
        let bt = UIButton()
        bt.setTitle("중고거래", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        bt.addTarget(self, action: #selector(used), for: .touchUpInside)
        return bt
    }()
    
    let usedButton: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 40
        bt.setImage(UIImage(named: "write")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        bt.setImage(UIImage(named: "write")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .highlighted)
        bt.addTarget(self, action: #selector(used), for: .touchUpInside)
        return bt
    }()
    
    let neighborTitle: UIButton = {
        let bt = UIButton()
        bt.setTitle("동네홍보", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        bt.addTarget(self, action: #selector(neighbor), for: .touchUpInside)
        return bt
    }()
    
    let neighborButton: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 40
        bt.setImage(UIImage(named: "neighbor")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        bt.setImage(UIImage(named: "neighbor")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .highlighted)
        bt.addTarget(self, action: #selector(neighbor), for: .touchUpInside)
        return bt
    }()
    
    let toastText: UIButton = {
        let bt = UIButton()
        let size: CGFloat = 5
        bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.frame.size = CGSize(width: UIScreen.main.bounds.width - 20, height: 50)
        return bt
    }()
    
    @objc func neighbor() {
        print("동네홍보 클릭")
    }
    
    @objc func used() {
        print("중고거래 클릭")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private let window = FloatingButtonWindow()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }

    override func loadView() {
        super.loadView()
        setUpGenerator()
        setStackView()
        NotificationCenter.default.addObserver(self, selector: #selector(setToast), name: .locationChangedToast, object: nil)
    }
    
    func setStackView() {
        let view = UIView()
        let button = UIButton(type: .custom)
        
        let size: CGFloat = 60
        button.setImage(UIImage(named: "Add")?.scalePreservingAspectRatio(targetSize: CGSize(width: size, height: size)), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        button.addTarget(self, action: #selector(floatingButtonClicked(_:)), for: .touchUpInside)
        
        self.usedStackView = UIStackView.init(arrangedSubviews: [usedTitle, usedButton])
        self.neighborStackView = UIStackView.init(arrangedSubviews: [neighborTitle, neighborButton])
        
        [usedStackView,neighborStackView].forEach { item in
            item.axis = .horizontal
            item.spacing = 15
            item.isLayoutMarginsRelativeArrangement = true
            item.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        self.usedStackView.isHidden = true
        self.neighborStackView.isHidden = true
        self.toastText.isHidden = true
        
        self.floatingStackView = UIStackView.init(arrangedSubviews: [neighborStackView, usedStackView, button, toastText])
        
        floatingStackView.distribution = .equalSpacing
        floatingStackView.spacing = 15
        floatingStackView.axis = .vertical
        floatingStackView.alignment = .trailing
        
        view.addSubview(floatingStackView)
            
        let vc = HomeViewController()
        
        floatingStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(95)
        }
        
        self.view = view
        self.AddButton = button
        
        window.stackView = floatingStackView
        window.button = button
        window.customView = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func setToast() {
        UIView.animate(withDuration: 0) {
            self.toastText.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            UIView.animate(withDuration: 0.5) {
                self.toastText.isHidden = true
            }
        }
    }
    
    var isShowFloating: Bool = false
    
    /// 객체 호출 시 생성할 수 있도록
    lazy var buttons = [usedStackView, neighborStackView]
    
    @objc func floatingButtonClicked(_ sender: UIButton) {
        
        
        let imgSize: CGFloat = 60
                        
        if isShowFloating {
            self.view.isUserInteractionEnabled = true
            hideViewWhenTappedAround(self.view)
            
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                
            }) { (_) in
                self.view.backgroundColor = .none
                
            }
        } else {
            self.feedBackGenerator?.notificationOccurred(.success)

            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            buttons.forEach { [weak self] stack in
                UIView.animate(withDuration: 0.3) {
                    stack.isHidden = false
                    self?.view.layoutIfNeeded()
                }
                
            }
        }
        
        self.isShowFloating = !isShowFloating
        
        let image = isShowFloating ? UIImage(named: "cancel") : UIImage(named: "Add")
        let rotation = isShowFloating ? CGAffineTransform(rotationAngle: .pi - (.pi / 2)) : CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            sender.setImage(image?.scalePreservingAspectRatio(targetSize: CGSize(width: imgSize, height: imgSize)), for: .normal)
            sender.transform = rotation
        }
    }

}

public class FloatingButtonWindow: UIWindow {

    var stackView: UIStackView?
    var button: UIButton?
    var customView: UIView?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let stack = stackView else { return false }
        let stackPoint = convert(point, to: stack)
        return stack.point(inside: stackPoint, with: event)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        if touch?.view == customView {
            customView?.alpha = 0
        }
    }
}

extension FloatingButtonController {
    func hideViewWhenTappedAround(_ item: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        tap.cancelsTouchesInView = false
        
        item.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        print("끄읕sdfasfsfsaef")
        let imgSize: CGFloat = 60
        
        buttons.map {$0.isHidden = true}
        
        let image = UIImage(named: "Add")
        let rotation = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            self.AddButton.setImage(image?.scalePreservingAspectRatio(targetSize: CGSize(width: imgSize, height: imgSize)), for: .normal)
            self.AddButton.transform = rotation
        }
        isShowFloating = !isShowFloating
    }
}