//
//  Contents_HeaderCell.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/07/18.
//

import UIKit
import SnapKit

class Contents_HeaderCell: UITableViewHeaderFooterView {
        
    static let identifier = "ContentsHeaderCell"
    
    var images = ["당근이","당근이","당근이","당근이","당근이"]
        
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    
    let prodImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "당근이")
        
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        
        return pc
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        scrollView.delegate = self
        addScrollView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Contents_HeaderCell: UIScrollViewDelegate {
    func addScrollView() {
        addSubview(scrollView)
        addSubview(pageControl)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        pageControl.numberOfPages = images.count
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for index in 0..<images.count {
            let imageView = UIImageView(frame: frame)
            let xPos = self.contentView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = UIImage(named: images[index]) //?.scalePreservingAspectRatio(targetSize: CGSize(width: 390, height: 420))
            self.scrollView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(index + 1)
            print(contentView.frame.width)
        }
        
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(value)
    }
}
