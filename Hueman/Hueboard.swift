//
//  Hueboard.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/20/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

struct Hueboard {
    
    let title: String?
    let coverImage: UIImage?
    let annotation: String?
    let ownerName: String?
    let ownerImage: UIImage?
    
    init(title: String, coverImage:String, annotation: String, ownerName: String, ownerImage: String) {
        self.title = title
        self.coverImage = UIImage(named: coverImage)
        self.annotation = annotation
        self.ownerName = ownerName
        self.ownerImage = UIImage(named: ownerImage)
    }
}
