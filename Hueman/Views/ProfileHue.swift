//
//  ProfileHue.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
enum Mode {
    case edit
    case add
}
class ProfileHue: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var plus: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var edit: UIImageView!
    

    
    var mode: Mode? {
        didSet {
            if let unwrappedMode = mode {
                if unwrappedMode == .edit {
                    if descriptionLabel.text!.isEmpty || descriptionLabel.text?.characters.count == 0 {
                        plus.hidden = false
                        edit.hidden = true

                    }else {
                        edit.hidden = false
                        
                    }
                }else {
                    edit.hidden = true
                }
            }else {
                edit.hidden = true
            }

            
        }
        

    }
    
    
    var type: String? {
        didSet {
            descriptionLabel.hidden = true
            plus.image = UIImage(named: "create-plus-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            plus.tintColor = UIColor.UIColorFromRGB(0x666666)
            titleLabel.textColor = UIColor.UIColorFromRGB(0x666666)
            
            if mode == nil || mode == .add || edit != nil {
                edit.hidden = true
            }
            
            if let unwrappedType = type {
                
                switch unwrappedType {
                    
                    
                case Topic.Wanderlust:
                    icon.image = UIImage(named: "hue-wanderlust-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)
                   // self.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                    titleLabel.text = "wanderlust"

                    break
                    
                case Topic.OnMyPlate:
                    icon.image = UIImage(named: "hue-plate-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)

                  //  self.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                    
                    titleLabel.text = "on my plate"

                    break
                    
                case Topic.RelationshipMusing:
                    icon.image = UIImage(named: "hue-love-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)

                //    self.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                    titleLabel.text = "love musings"

                    break
                    
                case Topic.Health:
                    icon.image = UIImage(named: "hue-health-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)

                  //  self.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                    titleLabel.text = "oh health yeah"

                    break
                    
                case Topic.DailyHustle:
                    icon.image = UIImage(named: "hue-hustle-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)

                  //  self.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                    titleLabel.text = "daily hustle"

                    break
                    
                    
                    
                default:
                    icon.image = UIImage(named: "hue-ray-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)

                 //   self.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                    titleLabel.text = "ray of light"

                    break
                }
                

                let screenWidth = UIScreen.mainScreen().bounds.size.width
                let screenHeight = UIScreen.mainScreen().bounds.size.height
                
                
                let maxLength = max(screenWidth, screenHeight)
                //     let minLength = min(screenWidth, screenHeight)
                
                
                if  UIDevice.currentDevice().model == "iPhone" && maxLength == 568 {
                    
                    var viewFrame = icon.frame
                    icon.frame = CGRectMake(viewFrame.origin.x , viewFrame.origin.y - 15, viewFrame.size.width, viewFrame.size.height)
                    
                    viewFrame = titleLabel.frame
                    titleLabel.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y - 18, viewFrame.size.width, viewFrame.size.height)
                    
                    viewFrame = descriptionLabel.frame
                    descriptionLabel.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y - 22, viewFrame.size.width, viewFrame.size.height)
                    
                    
                    viewFrame = plus.frame
                    plus.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y - 25, viewFrame.size.width, viewFrame.size.height)
                    

                    
                }
            }

        }
    }
    
    var data: ProfileHueModel? {
        didSet {
            
            if let unwrappedData = data {
                
                
                //titleLabel.text = ""
                let targetString = "\(unwrappedData.title) \(unwrappedData.description)"
                let range = NSMakeRange(0, unwrappedData.title.characters.count)
                descriptionLabel.attributedText = attributedString(from: targetString, nonBoldRange: range)
               // descriptionLabel.text = "\(unwrappedData.title) \(unwrappedData.description)"

                if unwrappedData.description.isEmpty {
                    plus.hidden = false
                    descriptionLabel.hidden = true
                    titleLabel.hidden = false
                    icon.tintColor = UIColor.UIColorFromRGB(0x666666)
                    titleLabel.textColor =  UIColor.UIColorFromRGB(0x666666)
                    if let unwrappedMode = mode {
                        if unwrappedMode == .edit {
                            edit.hidden = true
                        }
                    }
                }else {
                    plus.hidden = true
                    descriptionLabel.hidden = false
                    titleLabel.hidden = true
                    icon.tintColor = UIColor.whiteColor()
                    titleLabel.textColor = UIColor.whiteColor()
                    if let unwrappedMode = mode {
                        if unwrappedMode == .edit {
                            edit.hidden = false
                        }
                    }

                }
                
                if mode == nil {
                    edit.hidden = true
                }

                switch unwrappedData.type {
                    
                    
                case Topic.Wanderlust:
                    
                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.Wanderlust)
                    
                    break
                    
                case Topic.OnMyPlate:

                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.OnMyPlate)
                    
                    break
                    
                case Topic.RelationshipMusing:

                
                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.RelationshipMusing)
                    break
                    
                case Topic.Health:
                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.Health)
                    break
                    
                case Topic.DailyHustle:

                    
                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.DailyHustle)
                    break
                    
                    
                    
                default:
                    
                    self.backgroundColor = unwrappedData.description.isEmpty ?  UIColor.UIColorFromRGB(0xDDDDDD) :  UIColor.UIColorFromRGB(Color.RayOfLight)
                    break
                }
            }
            
            

        }
    }
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        
        plus.image = UIImage(named: "create-plus-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        plus.tintColor = UIColor.UIColorFromRGB(0x666666)

        descriptionLabel.hidden = true
        edit.hidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

       // fatalError("init(coder:) has not been implemented")
    }
    

    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        
        var fontSize = UIFont.systemFontSize()

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
    
        
        let maxLength = max(screenWidth, screenHeight)
        //     let minLength = min(screenWidth, screenHeight)
        
        
        if  UIDevice.currentDevice().model == "iPhone" && maxLength == 568 {
            fontSize = 12
            
        }
        
        let attrs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(fontSize),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.systemFontOfSize(fontSize)
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
