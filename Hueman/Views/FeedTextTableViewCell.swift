//
//  FeedTextTableViewCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 11/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class FeedTextTableViewCell: UITableViewCell {

    @IBOutlet weak var textFeedLabel: UILabel!

    @IBOutlet weak var textAuthorLabel: UILabel!
    
    var feed: Feed? {
        didSet{
            if let feed = feed {
                textFeedLabel.text = feed.text
                textAuthorLabel.text = feed.author
            }
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func didTapComment(sender: AnyObject) {
        print("didTapComment")
    }
    @IBAction func didTapLike(sender: AnyObject) {
        print("didTapLike")
    }

}
