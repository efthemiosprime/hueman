//
//  ProfileHue.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ProfileHue: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var plus: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    

    var type: String? {
        didSet {
            descriptionLabel.hidden = true
            plus.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            plus.tintColor = UIColor.UIColorFromRGB(0x666666)
            titleLabel.textColor = UIColor.UIColorFromRGB(0x666666)
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
                
                
            }

        }
    }
    
    var data: ProfileHueModel? {
        didSet {
                
            if let unwrappedData = data {
            
                icon.tintColor = UIColor.whiteColor()
                titleLabel.text = unwrappedData.title
                descriptionLabel.text = unwrappedData.description
                titleLabel.textColor = UIColor.whiteColor()

                plus.hidden = true
                descriptionLabel.hidden = false

                switch unwrappedData.type {
                    
                    
                case Topic.Wanderlust:

                    self.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                    
                    break
                    
                case Topic.OnMyPlate:

                     self.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                    
                    
                    break
                    
                case Topic.RelationshipMusing:

                
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                    
                    break
                    
                case Topic.Health:
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                    
                    break
                    
                case Topic.DailyHustle:

                    
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                    
                    break
                    
                    
                    
                default:
                    
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                    
                    break
                }
            }
        }
    }
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        descriptionLabel.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

       // fatalError("init(coder:) has not been implemented")
    }
    

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
