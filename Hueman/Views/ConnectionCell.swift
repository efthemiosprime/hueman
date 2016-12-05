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
                locationLabel.text = connection.location
                //connectionImage.image = UIImage(named: connection.imageURL!)
                connectionImage.clipsToBounds = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
