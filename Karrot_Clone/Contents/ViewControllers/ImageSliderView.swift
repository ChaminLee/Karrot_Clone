//
//  ImageSliderView.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/28.
//

import UIKit
import SnapKit

class ImageSliderView: UIView, UIScrollViewDelegate {

    var images = ["당근이","당근이2","당근이3","당근이4","당근이5"]
    
    var scrollViewHeight = NSLayoutConstraint()
    var scrollViewBottom = NSLayoutConstraint()
    
    var containerView: UIView!
    var scrollView: UIScrollView!
    
    var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {
        containerView = UIView()
        self.addSubview(containerView)
        
        let headerHeight = 400
        let headerWidth = Int(self.containerView.frame.width)
        scrollView = UIScrollView()
        
        // 페이지 컨트롤
        let pageControl = UIPageControl() 
        pageControl.frame = CGRect(x: 0, y: headerHeight - 30, width: headerWidth , height: 10)
        pageControl.numberOfPages = images.count

        // 스크롤 뷰
        scrollView.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)

        scrollView.delegate = self

        for index in 0..<images.count {
            let imageView = UIImageView()
            imageView.layer.masksToBounds = false
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOffset = CGSize(width: 0, height: -10)
            imageView.layer.shadowRadius = 2
            imageView.layer.shadowOpacity = 0.25
            imageView.clipsToBounds = true

            let xPos = CGFloat(headerWidth) * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = UIImage(named: images[index])
            scrollView.addSubview(imageView)

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        }

        scrollView.contentSize.width = scrollView.frame.width * CGFloat(images.count)
        
        containerView.addSubview(scrollView)
    }
    
    func setConfig() {
        self.snp.makeConstraints {
            $0.width.equalTo(containerView.snp.width)
            $0.centerX.equalTo(containerView.snp.centerX)
            $0.height.equalTo(containerView.snp.height)
        }
        
        containerView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
        }
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        scrollViewBottom = scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        scrollViewHeight = scrollView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        scrollViewBottom.isActive = true
        scrollViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        scrollViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        scrollViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
