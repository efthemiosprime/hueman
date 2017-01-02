//
//  DrawerImageProfileCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class DrawerProfileImageRowCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!

    var showProfileAction: ((UITableViewCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        

        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(profileImageTapGesture)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func profileImageTapped() {
        showProfileAction?(self)
    }

}
