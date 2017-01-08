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
    
    @IBOutlet weak var textCreatedLabel: UILabel!

    @IBOutlet weak var textAuthorLabel: UILabel!
    
    @IBOutlet weak var authorProfileImage: UIImageView!

    @IBOutlet weak var popoverButton: UIButton!
    
    @IBOutlet weak var likesButton: UIButton!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var flagButton: UIButton!
    
    
    var key: String!

    
    var showCommentsAction: ((UITableViewCell) -> Void)?
    var showLikesAction: ((UITableViewCell) -> Void)?
    
    var feed: Feed? {
        didSet{
            if let feed = feed {
                textFeedLabel.text = feed.text
                textAuthorLabel.text = feed.author
                textCreatedLabel.text = feed.dateCreated ?? ""
                key = feed.key
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
    
    @IBAction func didTappedCommentAction(sender: AnyObject) {
        showCommentsAction?(self)
    }
    

    @IBAction func didTappedLikeAction(sender: AnyObject) {
        likesButton.enabled = false
        showLikesAction?(self)
    }


}
