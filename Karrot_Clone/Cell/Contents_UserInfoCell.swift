//
//  Contents_UserInfoCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import Foundation
import UIKit
import SnapKit

class Contents_UserInfoCell: UITableViewCell {

    static let identifier = "Contents_UserInfoCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
        self.mannerInfo.addTarget(self, action: #selector(mannerClicked(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonAction: (() -> ())?
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        img.image = UIImage(named: "당근이")?.scalePreservingAspectRatio(targetSize: CGSize(width: 45, height: 45))
        img.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.width / 2
        img.clipsToBounds = true
            
        return img
    }()
    
    let idLabel: UILabel = {
        let lb = UILabel()
        lb.text = "정자동불주먹"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 15)
        return lb
    }()
    
    let townLabel: UILabel = {
        let lb = UILabel()
        lb.text = "정자동"
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let degreeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "36.5℃"
        lb.textColor = UIColor(named: CustomColor.text.rawValue) // by Lv
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 16)
        return lb
    }()
    
    let degreeBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.setProgress(0.365, animated: true)
        pv.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pv.progressTintColor = UIColor.blue // by Lv
        
        // rounded border
        for view in pv.subviews {
            if view is UIImageView {
                view.clipsToBounds = true
                view.layer.cornerRadius = view.frame.height / 2 + 1
            }
        }
        return pv
    }()
    
    let degreeIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "smile")?.scalePreservingAspectRatio(targetSize: CGSize(width: 23, height: 23))
        return img
    }()
    
    var mannerInfo: UIButton = {
        let bt = UIButton()
        bt.setTitle("매너온도", for: .normal)
        bt.setTitleColor(UIColor(named: CustomColor.reply.rawValue), for: .normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        return bt
    }()
    
    @objc func mannerClicked(_ sender: UIButton) {
        buttonAction?()
    }
    
    
    
    func config() {
        contentView.isUserInteractionEnabled = true
        
        [profileImage, idLabel, townLabel, degreeLabel, degreeBar, degreeIcon, mannerInfo].forEach { item in
            contentView.addSubview(item)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top).offset(3)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        townLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom).inset(3)
            $0.leading.equalTo(idLabel.snp.leading)
        }
        
        degreeIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.top.equalToSuperview().offset(25)
        }
        
        degreeLabel.snp.makeConstraints {
            $0.trailing.equalTo(degreeIcon.snp.leading).offset(-10)
            $0.top.equalTo(profileImage.snp.top).offset(-5)
        }
        
        degreeBar.snp.makeConstraints {
            $0.top.equalTo(degreeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(degreeLabel.snp.leading)
            $0.trailing.equalTo(degreeLabel.snp.trailing)
            $0.height.equalTo(3)
        }
        
        mannerInfo.snp.makeConstraints {
            $0.top.equalTo(degreeIcon.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(15)
        }
        
    }

}


extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

extension Contents_UserInfoCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
