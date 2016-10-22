//
//  ConnectionRightCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionRightCell: UITableViewCell {

    @IBOutlet weak var connectionName: UILabel!
    @IBOutlet weak var item: ConnectionRightItem!
    @IBOutlet weak var profileImage: UIImageView!
    
    var profile: Profile? {
        didSet {
            if let profile = profile {
                self.connectionName.text = profile.name?.uppercaseString
                item.hueColor = profile.hueColor
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        item.backgroundColor = UIColor.clearColor()
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        
        connectionName.numberOfLines = 0
        connectionName.textAlignment = .Center
        connectionName.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
