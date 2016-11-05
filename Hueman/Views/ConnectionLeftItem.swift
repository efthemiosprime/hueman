//
//  ConnectionLeftItem.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionLeftItem: UIView{

    var hueColor: UIColor?
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
        
        self.hueColor = UIColor.UIColorFromRGB(0x93648D)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        //// Color Declarations
      //  let strokeColor = UIColor(red: 0.200, green: 0.710, blue: 0.827, alpha: 1.000)
     //   let fillColor = UIColor(red: 0.200, green: 0.710, blue: 0.827, alpha: 1.000)\
        
        let fillColor = (hueColor != nil) ? hueColor : UIColor.UIColorFromRGB(0x93648D)
 
        //// outterStroke Drawing
        let outterStrokePath = UIBezierPath(ovalInRect: CGRect(x: 2, y: 2, width: 134, height: 134))
        fillColor!.setStroke()
        outterStrokePath.lineWidth = 4
        outterStrokePath.stroke()
 
 
        //// thumbnailBackground Drawing
        let thumbnailBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 8.75, y: 8.75, width: 120.5, height: 120.5))
        fillColor!.setFill()
        thumbnailBackgroundPath.fill()
 
 
    }

}
