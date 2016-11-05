//
//  ConnectionLabel.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/24/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionLabel: UIView {

    var label: UILabel?
    var hueColor: UIColor?
    
    var nameLabel: String? {
        didSet {
            if let name = nameLabel {
                
                let formattedName = name.stringByReplacingOccurrencesOfString(" ", withString: "\n").uppercaseString
                label?.text = formattedName

            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()

        
        label =  UILabel()
        label?.textAlignment = .Center
        label?.lineBreakMode = .ByWordWrapping
        label?.adjustsFontSizeToFitWidth = true
        
        label?.numberOfLines = 0
        label?.font = UIFont(name: Font.SofiaProBold, size: 16)
        label?.textColor = UIColor.whiteColor()
        label?.frame = CGRectMake(0, 10, self.frame.width, 100)
        self.addSubview(label!)
    }
    

    override func drawRect(rect: CGRect) {
        //// Color Declarations
        let blacClr = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.490)
        let whiteClr = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// offset Drawing
        let offsetPath = UIBezierPath(ovalInRect: CGRect(x: 1.5, y: 1.55, width: 117.4, height: 117.4))
        blacClr.setFill()
        offsetPath.fill()
        
        
        //// outer Drawing
        let outerPath = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0.05, width: 117.4, height: 117.4))
        whiteClr.setFill()
        outerPath.fill()
        
        
        //// inner Drawing
        let innerPath = UIBezierPath(ovalInRect: CGRect(x: 7.95, y: 8.05, width: 101.5, height: 101.4))
        self.hueColor!.setFill()
        innerPath.fill()

    }
 

}
