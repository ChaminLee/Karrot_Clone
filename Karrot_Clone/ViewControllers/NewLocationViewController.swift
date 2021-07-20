//
//  NewLocationViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/20.
//

import UIKit
import SnapKit

class NewLocationViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        config()
    }
    
    let xbutton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "xmark"), for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.setTitleColor(UIColor(named: CustomColor.text.rawValue), for: .normal)
        bt.addTarget(self, action: #selector(close), for: .touchUpInside)
        return bt
    }()

    @objc func close() {
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        if self.presentingViewController != nil {
//            self.dismiss(animated: true) {
//                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }
//        }
        self.dismiss(animated: true, completion: nil)

        
//        if self.presentingViewController != nil {
////            self.dismiss(animated: true) {
////                self.navigationController?.popToRootViewController(animated: true)
////            }
//            self.dismiss(animated: true, completion: nil)
//        } else {
//            self.navigationController!.popToRootViewController(animated: true)
//        }
    }
    
    func config() {
        view.addSubview(xbutton)
        
        xbutton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(50)
        }
    }
}
