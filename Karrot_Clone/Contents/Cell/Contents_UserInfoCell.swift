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
    
    /// Contents - UserInfo - 매너온도 버튼 팝업을 위해서 클로저 타입으로 선언
    var buttonAction: (() -> ())?
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        img.image = UIImage(named: "당근이")?.scalePreservingAspectRatio(targetSize: CGSize(width: 45, height: 45))
        img.layer.cornerRadius = img.frame.width / 2
        img.layer.borderWidth = 0.5
        img.layer.borderColor = UIColor(named: CustomColor.reply.rawValue)?.cgColor
        img.clipsToBounds = true
            
        return img
    }()
    
    let idLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 15)
        return lb
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue)
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 13)
        return lb
    }()
    
    let degreeLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor(named: CustomColor.text.rawValue) // by Lv
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 16)
        return lb
    }()
    
    let degreeBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.trackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        /// Progressbar rounded border
        for view in pv.subviews {
            if view is UIImageView {
                view.clipsToBounds = true
                view.layer.cornerRadius = view.frame.height / 2 + 1
            }
        }
        return pv
    }()
    
    /// 온도에 따른 이미지 변경 필요 (현재는 이미지 더 추가해야할 필요가 있음)
    let degreeIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "smile")?.scalePreservingAspectRatio(targetSize: CGSize(width: 23, height: 23))
        return img
    }()
    
    var mannerInfo: UIButton = {
        let bt = UIButton()
        let attr = bt.addBottomLine(font: UIFont(name: "Helvetica", size: 12)!, color: UIColor(named: CustomColor.reply.rawValue)!, string: "매너온도")
        bt.setAttributedTitle(attr, for: .normal)
        return bt
    }()
    
    /// 매너온도 버튼 클릭 시, 클로저로 선언한 액션 실행
    @objc func mannerClicked(_ sender: UIButton) {
        buttonAction?()
    }
    
    /// 초기 세팅
    func config() {
        [profileImage, idLabel, locationLabel, degreeLabel, degreeBar, degreeIcon, mannerInfo].forEach { item in
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
        
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImage.snp.bottom).inset(3)
            $0.leading.equalTo(idLabel.snp.leading)
            $0.top.equalTo(idLabel.snp.bottom).offset(5)
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

/// Popover modal style 선택
extension Contents_UserInfoCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
