//
//  CommentCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation


import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var commentText: UILabel!
    
    var comment: Comment? {
        didSet {
            if let comment = comment {
                self.name.text = comment.name
                self.commentText.text = comment.text

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
