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
    
    
    var addUserAction: ((AddUserCell) -> Void)?

    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                locationLabel.text = user.location
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
    
    
    @IBAction func didTappedAddUser(sender: AnyObject) {
        addUserAction?(self)
    }
    
}
