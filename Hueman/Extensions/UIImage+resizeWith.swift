//
//  UIImage+resizeWith.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/23/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

extension UIImage {

    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .ScaleToFill
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}


// Usage: 
// let myPicture = UIImage(data: try! Data(contentsOf: URL(string: "http://")!))!
// let myThumb2 = myPicture.resizeWith(width: 72.0)
