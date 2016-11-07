//
//  PickHuesViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

class PickHuesViewModel {
    var hueColors: [UInt] = [UInt]()
    var hueIcons: [String] = [String]()
    
    init() {
        hueColors.append(Color.Wanderlust)
        hueColors.append(Color.OnMyPlate)
        hueColors.append(Color.RelationshipMusing)
        hueColors.append(Color.Health)
        hueColors.append(Color.DailyHustle)
        hueColors.append(Color.RayOfLight)
        
        hueIcons.append(Icon.Wanderlust)
        hueIcons.append(Icon.OnMyPlate)
        hueIcons.append(Icon.RelationshipMusing)
        hueIcons.append(Icon.Health)
        hueIcons.append(Icon.DailyHustle)
        hueIcons.append(Icon.RayOfLight)
    }
}
