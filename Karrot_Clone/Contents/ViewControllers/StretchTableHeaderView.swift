//
//  StretchTableViewHeaderView.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/08/03.
//

import UIKit
import SnapKit

class StretchTableHeaderView: UIView {

    var sliderHeight = NSLayoutConstraint()
    var sliderBottom = NSLayoutConstraint()
    var imageViewTop = NSLayoutConstraint()
    lazy var images = [String]() //["당근이7","당근이3","당근이4"]
    
    var containerView: UIView!
    
    var sliderView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 390))
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.backgroundColor = .yellow
        return sv
    }()
    
    var imageView: UIImageView!
    var pageControl: UIPageControl = {
        let pc = UIPageControl(frame: CGRect(x: 0, y: 390 - 30, width: UIScreen.main.bounds.size.width , height: 10))

        return pc
    }()
    
    var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
        setViewConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func createViews() {
        // Container View
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 390))
        self.addSubview(containerView)
    
        sliderView.delegate = self
        
        containerView.addSubview(sliderView)
        containerView.addSubview(pageControl)
        
    }
    
    func setViewConstraints() {
        
        pageControl.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
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

        // ImageView Constraints
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        sliderBottom = sliderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        sliderBottom.isActive = true
        sliderHeight = sliderView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        sliderHeight.isActive = true
    }
    
    func pushDownScroll(scrollView: UIScrollView) {
//        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        sliderBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        sliderHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
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