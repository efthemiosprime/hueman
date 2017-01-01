//
//  UserCell.swift
//  Hueman
//
//  Created by Efthemios Suyat on 12/16/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit


class AddUserCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var connectionImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    var addUserAction: ((AddUserCell) -> Void)?
    var friendship: Friendship?

    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                locationLabel.text = user.location
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
    
    
    @IBAction func didTappedAddUser(sender: AnyObject) {
        addUserAction?(self)
    }
    
}
