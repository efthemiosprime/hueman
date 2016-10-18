//
//  HueboardCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/12/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class HueboardCell: UICollectionViewCell {

    @IBOutlet weak var roundedBackground: UIView!
    @IBOutlet weak var roundedWhiteBackground: RoundedCornersView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! HueboardsLayoutAttributes
        
    }
}
