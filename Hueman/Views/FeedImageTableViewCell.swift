//
//  FeedImageTableViewCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/7/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class FeedImageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textFeedLabel: UILabel!
    
    @IBOutlet weak var textAuthorLabel: UILabel!

    @IBOutlet weak var feedImage: UIImageView!
    
    var feed: Feed? {
        didSet{
            if let feed = feed {
                textFeedLabel.text = feed.text
                textAuthorLabel.text = feed.author
               // feedImage.image = UIImage(named: "test")
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
