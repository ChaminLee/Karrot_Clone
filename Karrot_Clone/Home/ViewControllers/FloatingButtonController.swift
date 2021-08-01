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

    /// 초기에 노출될 + 버튼
    var AddButton: UIButton!
    /// 중고거래 ( 텍스트 + 버튼 )
    var usedStackView = UIStackView()
    /// 동네홍보 ( 텍스트 + 버튼 )
    var neighborStackView = UIStackView()
    /// 전체를 감싸는 StackView
    var floatingStackView = UIStackView()
    
    /// floatingStackView가 펼쳐질 때 진동 추가하기 위함
    var feedBackGenerator: UINotificationFeedbackGenerator?
    
    /// 진동 초기 세팅
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
    
    /// Dummy View생성  >  + 버튼을 띄우기 위해
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
    
    /// window에 추가하여 background를 dimmed 시키기
    private let window = FloatingButtonWindow()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        /// window 최상단에 위치
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }

    /// 1. setUpGenerator() : 진동을 위한 세팅
    /// 2. setStackView() : 버튼 StackView 세팅
    /// 3. NotificationCenter : Toast Popup 수신 대기
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
        
        self.usedStackView = UIStackView(arrangedSubviews: [usedTitle, usedButton], axis: .horizontal, spacing: 15, alignment: .center, distribution: .fill)
        self.neighborStackView = UIStackView(arrangedSubviews: [neighborTitle, neighborButton], axis: .horizontal, spacing: 15, alignment: .center, distribution: .fill)
        
        /// 우측 마진 추가 - 이미지를  (+) 기준으로 가운데 정렬시키기 위해
        [usedStackView,neighborStackView].forEach { item in
            item.isLayoutMarginsRelativeArrangement = true
            item.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        self.usedStackView.isHidden = true
        self.neighborStackView.isHidden = true
        self.toastText.isHidden = true
        
        self.floatingStackView = UIStackView(arrangedSubviews: [neighborStackView, usedStackView, button, toastText], axis: .vertical, spacing: 15, alignment: .trailing, distribution: .equalSpacing)
        
        view.addSubview(floatingStackView)
                    
        floatingStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(95)
        }
        
        /// 할당
        self.view = view
        self.AddButton = button
        
        window.stackView = floatingStackView
        window.button = button
        window.customView = view
    }
    
    /// Dummy Toast View 등장해서 floatingStackView 높이 조절
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
    
    /// Floating의 State
    var isShowFloating: Bool = false
    
    /// 객체 호출 시 생성할 수 있도록
    lazy var buttons = [usedStackView, neighborStackView]
    
    @objc func floatingButtonClicked(_ sender: UIButton) {
        let imgSize: CGFloat = 60
                        
        if isShowFloating {
            self.view.isUserInteractionEnabled = true
            /// 뒷 배경 클릭시 닫히도록
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
    
    /// 터치가 가능하도록 > 나머지는 다 무시
    /// [ ] 배경이 떴을 때 무시하지 않도록 해줘야 함
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let stack = stackView else { return false }
        let stackPoint = convert(point, to: stack)
        return stack.point(inside: stackPoint, with: event)
    }
}

extension FloatingButtonController {
    func hideViewWhenTappedAround(_ item: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        item.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        let imgSize: CGFloat = 60
        
        buttons.map {$0.isHidden = true}
        
        let image = UIImage(named: "Add")
        /// 다시 원래 상태로 돌리기 
        let rotation = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            self.AddButton.setImage(image?.scalePreservingAspectRatio(targetSize: CGSize(width: imgSize, height: imgSize)), for: .normal)
            self.AddButton.transform = rotation
        }
        isShowFloating = !isShowFloating
    }
}
