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
            
            titleLabel.hidden = true

            
            if let unwrappedType = type {
                
                switch unwrappedType {
                    
                    
                case Topic.Wanderlust:
                    icon.image = UIImage(named: "hue-wanderlust-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                    descriptionLabel.text = "wanderlust"

                    break
                    
                case Topic.OnMyPlate:
                    icon.image = UIImage(named: "hue-plate-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                    descriptionLabel.text = "on my plate"

                    break
                    
                case Topic.RelationshipMusing:
                    icon.image = UIImage(named: "hue-health-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                    descriptionLabel.text = "love musings"

                    break
                    
                case Topic.Health:
                    icon.image = UIImage(named: "hue-health-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                    descriptionLabel.text = "oh health yeah"

                    break
                    
                case Topic.DailyHustle:
                    icon.image = UIImage(named: "hue-hustle-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                    descriptionLabel.text = "daily hustle"

                    break
                    
                    
                    
                default:
                    icon.image = UIImage(named: "hue-ray-icon")
                    self.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                    descriptionLabel.text = "ray of light"

                    break
                }
                
                
            }

        }
    }
    
    var data: ProfileHueModel? {
        didSet {
            
            if let unwrappedData = data {
            
                
                titleLabel.text = unwrappedData.title
                descriptionLabel.text = unwrappedData.description
                
                plus.hidden = true
                titleLabel.hidden = false
            }
        }
    }
    
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        titleLabel.hidden = true
        
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
