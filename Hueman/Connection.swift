//
//  Connection.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/9/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit


class Connection: UIView {
    
    var hueColor: UIColor?
    var hue: Hue?
    var connectionName: String?
    var direction: Int?

    init(name: String, hue: Hue, direction: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 128))
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        self.hue = hue
        switch hue {
        case .DailyHustle:
            self.hueColor = UIColorFromRGB(0x93648D)
            break
        case .Health:
            self.hueColor = UIColorFromRGB(0x7BC8A4)
            break
        case .OnMyPlate:
            self.hueColor = UIColorFromRGB(0xf8b243)
            break
        case .RayOfLight:
            self.hueColor = UIColorFromRGB(0xEACD53)
            break
        case .RelationshipMusing:
            self.hueColor = UIColorFromRGB(0xe2563b)
            break
        case .Wanderlust:
            self.hueColor = UIColorFromRGB(0x34b5d4)
            break
        }
        
        self.connectionName = name
        self.direction = direction
       // self.direction = direction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func drawRect(rect: CGRect) {
        if direction == 1 {
            drawLeft()
        }else {
            drawRight()
        }
    }
    
    
    
    func drawLeft() {

        //// Color Declarations
        let color = hueColor
        
        let dropShadow = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.498)
        let strokeLabelColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Group 2
        //// profileImageStroke Drawing
        let profileImageStrokePath = UIBezierPath(ovalInRect: CGRect(x: 5, y: 5, width: 118.7, height: 118.7))
        color!.setStroke()
        profileImageStrokePath.lineWidth = 4
        profileImageStrokePath.stroke()
        
        
        //// imageProfileBackground Drawing
        let imageProfileBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 10.95, y: 10.95, width: 106.8, height: 106.8))
        color!.setFill()
        imageProfileBackgroundPath.fill()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalInRect: CGRect(x: 116.4, y: 27.95, width: 78.8, height: 78.8))
        dropShadow.setFill()
        oval3Path.fill()
        
        
        //// labelStroke Drawing
        let labelStrokePath = UIBezierPath(ovalInRect: CGRect(x: 113.4, y: 24.95, width: 78.8, height: 78.8))
        strokeLabelColor.setFill()
        labelStrokePath.fill()
        
        
        //// labelBackground Drawing
        let labelBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: 118.75, y: 30.3, width: 68.1, height: 68.1))
        color!.setFill()
        labelBackgroundPath.fill()

        
        // 
        let image = UIImage(named: "hulyo.jpg")
        let imageThumb = UIImageView()
        imageThumb.contentMode = .ScaleAspectFill
        imageThumb.image = image
        imageThumb.frame = CGRectMake(15, 15, 98.5, 98.5)
        
        imageThumb.layer.cornerRadius = imageThumb.frame.size.width/2
        imageThumb.clipsToBounds = true

        self.addSubview(imageThumb)
        
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(120, 34, 65, 65)
        nameLabel.textAlignment = .Center
        
        nameLabel.adjustsFontSizeToFitWidth = true;
        nameLabel.minimumScaleFactor=0.5;
        nameLabel.font = UIFont(name: "SofiaPro-Bold", size: 12)

        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text =  connectionName!.uppercaseString
        self.addSubview(nameLabel)
        
    }
    
    func drawRight() {
        //// Color Declarations
        let color = hueColor


        let dropShadow = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.498)
        let strokeLabelColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Group 2
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalInRect: CGRect(x: 73.9, y: 4, width: 119.4, height: 119.4))
        color!.setStroke()
        ovalPath.lineWidth = 4
        ovalPath.stroke()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalInRect: CGRect(x: 79.9, y: 10, width: 107.4, height: 107.4))
        color!.setFill()
        oval2Path.fill()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalInRect: CGRect(x: 8, y: 27.05, width: 79.3, height: 79.3))
        dropShadow.setFill()
        oval3Path.fill()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 5, y: 63.68))
        bezierPath.addCurveToPoint(CGPoint(x: 44.64, y: 103.32), controlPoint1: CGPoint(x: 5, y: 85.58), controlPoint2: CGPoint(x: 22.75, y: 103.32))
        bezierPath.addCurveToPoint(CGPoint(x: 84.28, y: 63.68), controlPoint1: CGPoint(x: 66.53, y: 103.32), controlPoint2: CGPoint(x: 84.28, y: 85.58))
        bezierPath.addCurveToPoint(CGPoint(x: 44.64, y: 24.05), controlPoint1: CGPoint(x: 84.28, y: 41.79), controlPoint2: CGPoint(x: 66.53, y: 24.05))
        bezierPath.addCurveToPoint(CGPoint(x: 5, y: 63.68), controlPoint1: CGPoint(x: 22.75, y: 24.05), controlPoint2: CGPoint(x: 5, y: 41.79))
        bezierPath.closePath()
        strokeLabelColor.setFill()
        bezierPath.fill()
        
        
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalInRect: CGRect(x: 10.4, y: 29.45, width: 68.5, height: 68.5))
        color!.setFill()
        oval5Path.fill()

        
        let image = UIImage(named: "hulyo.jpg")
        let imageThumb = UIImageView()
        imageThumb.contentMode = .ScaleAspectFill
        imageThumb.image = image
        imageThumb.frame = CGRectMake(86, 15, 96, 96)
        
        imageThumb.layer.cornerRadius = imageThumb.frame.size.width/2
        imageThumb.clipsToBounds = true
        
        self.addSubview(imageThumb)
        
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(11, 34, 65, 65)
        nameLabel.textAlignment = .Center

        nameLabel.adjustsFontSizeToFitWidth = true;
        nameLabel.minimumScaleFactor=0.5;
        nameLabel.font = UIFont(name: "SofiaPro-Bold", size: 12)
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text =  connectionName!.uppercaseString
        self.addSubview(nameLabel)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
