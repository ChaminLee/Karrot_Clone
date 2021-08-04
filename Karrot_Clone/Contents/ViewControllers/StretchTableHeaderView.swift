//
//  StretchTableViewHeaderView.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/08/03.
//

import UIKit
import SnapKit

class StretchTableHeaderView: UIView {

    let headerWidth: CGFloat = UIScreen.main.bounds.size.width
    let headerHeight: CGFloat = 390
    
    var sliderHeight = NSLayoutConstraint()
    var sliderBottom = NSLayoutConstraint()
    var containerViewHeight = NSLayoutConstraint()
    
    var images = [String]()
    
    var containerView: UIView!
    
    let botttomGradient: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.locations = [0.0, 1.0]
        gl.colors = [UIColor.clear.cgColor, UIColor.lightGray.withAlphaComponent(0.4).cgColor]
        return gl
    }()
    
    var sliderView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.backgroundColor = .yellow
        return sv
    }()
    
    var imageView: UIImageView!
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        return pc
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
//        setImages(images)
        setViewConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func createViews() {
        // Container View
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 390))
        self.addSubview(containerView)
    
        botttomGradient.frame = CGRect(x: 0, y: headerHeight - 40, width: headerWidth, height: 40)
        pageControl.frame = CGRect(x: 0, y: headerHeight - 30, width: headerWidth , height: 5)
        sliderView.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
        sliderView.delegate = self
    
        containerView.addSubview(sliderView)
        containerView.layer.addSublayer(botttomGradient)
        containerView.addSubview(pageControl)
        containerView.backgroundColor = UIColor.clear
    }
    
    func setImages(_ images: [String]) {
        pageControl.numberOfPages = images.count
        

        for i in 0..<images.count {
            imageView = UIImageView()
            let xPos = self.sliderView.bounds.width * CGFloat(i)
            print("xPos: \(xPos)")
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: images[i])
            imageView.frame = CGRect(x: xPos, y: 0, width: self.sliderView.bounds.width, height: self.sliderView.bounds.height)
            imageView.contentMode = .scaleAspectFill
            self.sliderView.addSubview(imageView)

        }

        self.sliderView.contentSize.width = CGFloat(images.count) * self.sliderView.frame.width
    }
    func setViewConstraints() {
        pageControl.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])

        // Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.widthAnchor.constraint(equalTo: sliderView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true

        // sliderView Constraints
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        sliderBottom = sliderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        sliderBottom.isActive = true
        sliderHeight = sliderView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        sliderHeight.isActive = true
    }
    
//    func pushDownScroll(scrollView: UIScrollView) {
//        containerViewHeight.constant = scrollView.contentInset.top
//        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
//        containerView.clipsToBounds = offsetY <= 0
//        sliderBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
//        sliderHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
//    }
}

extension StretchTableHeaderView: UIScrollViewDelegate {
    
    private func setPageControl() {
        self.pageControl.numberOfPages = self.images.count
    }

    private func setPageControlSelectedPage(currentPage:Int) {
        self.pageControl.currentPage = currentPage
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value = self.sliderView.contentOffset.x/self.sliderView.frame.size.width
        self.setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}
