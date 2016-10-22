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
    
    init(name: String, topic:Hue) {
        self.name = name
        self.topic = topic
        
        switch topic {
        case .DailyHustle:
            self.hueColor = UIColor.UIColorFromRGB(0x93648D)
            break
        case .Health:
            self.hueColor = UIColor.UIColorFromRGB(0x7BC8A4)
            break
        case .OnMyPlate:
            self.hueColor = UIColor.UIColorFromRGB(0xf8b243)
            break
        case .RayOfLight:
            self.hueColor = UIColor.UIColorFromRGB(0xEACD53)
            break
        case .RelationshipMusing:
            self.hueColor = UIColor.UIColorFromRGB(0xe2563b)
            break
        case .Wanderlust:
            self.hueColor = UIColor.UIColorFromRGB(0x34b5d4)
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
