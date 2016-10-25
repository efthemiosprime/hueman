//
//  ConnectionRightItem.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionRightItem: UIView {

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
        let fillColor = (hueColor != nil) ? hueColor : UIColor.UIColorFromRGB(0x93648D)
        
        //// outerProfileBackground Drawing
        let outerProfileBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 99.2, y: 1.96, width: 133.9, height: 133.9))
        fillColor!.setStroke()
        outerProfileBackgroundPath.lineWidth = 4
        outerProfileBackgroundPath.stroke()
        
        
        //// innerProfileBackground Drawing
        let innerProfileBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 105.95, y: 9.71, width: 120.4, height: 120.4))
        fillColor!.setFill()
        innerProfileBackgroundPath.fill()
        
        
    }
 

}
