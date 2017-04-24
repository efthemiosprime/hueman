//
//  Onboarding.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/23/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation

struct Onboarding {
    
    var imageName: String?
    var description: String?
    var background: String?
    var title: String?

    
    init(title:String, imageName: String, background:String, description:String) {
        
        self.title = title
        self.imageName = imageName
        self.description = description
        self.background = background
        
    }


}
