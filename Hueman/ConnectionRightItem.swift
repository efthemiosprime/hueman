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
        let white = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let fillColor = (hueColor != nil) ? hueColor : UIColor.UIColorFromRGB(0x93648D)
        let fillColor4 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// outerProfileBackground Drawing
        let outerProfileBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 99.2, y: 1.96, width: 133.9, height: 133.9))
        fillColor!.setStroke()
        outerProfileBackgroundPath.lineWidth = 4
        outerProfileBackgroundPath.stroke()
        
        
        //// innerProfileBackground Drawing
        let innerProfileBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 105.95, y: 9.71, width: 120.4, height: 120.4))
        fillColor!.setFill()
        innerProfileBackgroundPath.fill()
        
        
        //// dropShadow Drawing
        let dropShadowPath = UIBezierPath(ovalInRect: CGRect(x: 1.5, y: 14.71, width: 117.4, height: 117.4))
        fillColor4.setFill()
        dropShadowPath.fill()
        
        
        //// outerLabelBackground Drawing
        let outerLabelBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 13.21, width: 117.4, height: 117.4))
        white.setFill()
        outerLabelBackgroundPath.fill()
        
        
        //// innerLabelBackground Drawing
        let innerLabelBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 7.95, y: 21.21, width: 101.5, height: 101.4))
        fillColor!.setFill()
        innerLabelBackgroundPath.fill()
    }
 

}
