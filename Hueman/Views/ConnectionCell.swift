//
//  ConnectionCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/5/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var connectionImage: UIImageView!
    
    var connection: Connection? {
        didSet {
            if let connection = connection {
                nameLabel.text = connection.name
                if let location = connection.location?.location {
                    locationLabel.text = location

                }
                //connectionImage.image = UIImage(named: connection.imageURL!)
                connectionImage.clipsToBounds = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let screenSize = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        if screenHeight <= 568 {
            let nameRectSize = nameLabel.frame
            nameLabel.frame.size = CGSizeMake(150, nameRectSize.height)
            nameLabel.adjustsFontSizeToFitWidth = true

            let locRectSize = locationLabel.frame.size
            locationLabel.frame.size = CGSizeMake(150, locRectSize.height)
            locationLabel.adjustsFontSizeToFitWidth = true

        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
