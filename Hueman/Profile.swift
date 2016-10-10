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
    
    init(name: String, topic:Hue) {
        self.name = name
        self.topic = topic
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
