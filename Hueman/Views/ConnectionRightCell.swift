//
//  ConnectionRightCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionRightCell: UITableViewCell {

    @IBOutlet weak var item: ConnectionRightItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var connectionLabel: ConnectionLabel!

    var profile: Profile? {
        didSet {
            if let profile = profile {
                connectionLabel.nameLabel = profile.name
                connectionLabel.hueColor = profile.hueColor
                item.hueColor = profile.hueColor
                profileImage.image = profile.imageView

            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        item.backgroundColor = UIColor.clearColor()
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        profileImage.contentMode = .ScaleAspectFill
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
