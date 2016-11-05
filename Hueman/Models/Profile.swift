//
//  Hues.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/10/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct Profile {
    let name: String?
    let topic: Hue?
    let hueColor: UIColor?
    let imageStr: String?
    let imageView: UIImage?
    
    init(name: String, image:String, topic:Hue) {
        
        self.name = name
        self.topic = topic
        self.imageStr = image
        self.imageView = UIImage(named: imageStr!)
        
        switch topic {
        case .DailyHustle:
            self.hueColor = UIColor.UIColorFromRGB(Color.DailyHustle)
            break
        case .Health:
            self.hueColor = UIColor.UIColorFromRGB(Color.Health)
            break
        case .OnMyPlate:
            self.hueColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
            break
        case .RayOfLight:
            self.hueColor = UIColor.UIColorFromRGB(Color.RayOfLight)
            break
        case .RelationshipMusing:
            self.hueColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
            break
        case .Wanderlust:
            self.hueColor = UIColor.UIColorFromRGB(Color.Wanderlust)
            break
        }
    }
}

enum Hue {
    case Wanderlust
    case OnMyPlate
    case RelationshipMusing
    case Health
    case DailyHustle
    case RayOfLight
}
