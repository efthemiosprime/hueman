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
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var contentHeight: CGFloat = 0
    var hueboard: Hueboard? {
        didSet{
            if let hueboard = hueboard {
                titleLabel.text = hueboard.title
                postLabel.text = hueboard.annotation
                profileNameLabel.text = hueboard.ownerName
                coverImage.image = hueboard.coverImage
                profileImage.image = hueboard.ownerImage
                
                titleLabel.sizeToFit()
                postLabel.sizeToFit()
                self.updateFrame()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! HueboardsLayoutAttributes
        attributes.cellHeight = contentHeight
    }
    
    
    func updateFrame() {
        contentHeight = titleLabel.frame.origin.y + titleLabel.frame.size.height + 5
        coverImage.frame = CGRectMake(coverImage.frame.origin.x, contentHeight, coverImage.frame.size.width, coverImage.frame.size.height)
        
        contentHeight = contentHeight + coverImage.frame.size.height + 10
        postLabel.frame = CGRectMake(postLabel.frame.origin.x, contentHeight, postLabel.frame.size.width, postLabel.frame.size.height)
        
        contentHeight = contentHeight + postLabel.frame.size.height + 5
        
        profileNameLabel.frame = CGRectMake(profileNameLabel.frame.origin.x, self.frame.size.height - 44, profileNameLabel.frame.size.width, profileNameLabel.frame.size.height)
        
    }
}
