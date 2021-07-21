//
//  TownViewController.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/15.
//

import UIKit
import SnapKit

class LifeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    let image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "준비중")
        return img
    }()
    
    func config() {
        view.backgroundColor = UIColor(named: CustomColor.background.rawValue)
        view.addSubview(image)
        
        image.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
