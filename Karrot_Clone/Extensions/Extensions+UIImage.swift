//
//  Extensions+UIImage.swift
//  Karrot_Clone
//
//  Created by 이차민 on 2021/08/01.
//

import Foundation
import UIKit

/// UIImage 스케일을 쉽게 조정하기 위함
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        /// aspect ratio를 보존하기 위해 스케일을 정해둠
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        /// aspect ratio를 유지하며 사이즈 조정
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        /// 사이즈 조절된 이미지 그리고 반환
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
