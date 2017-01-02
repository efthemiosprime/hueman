//
//  SidebarCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/1/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class SidebarCell: UITableViewCell {
    
    
    var showProfileAction: ((UITableViewCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
