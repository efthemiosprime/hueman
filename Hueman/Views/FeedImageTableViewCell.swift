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
    
    @IBOutlet weak var textCreatedLabel: UILabel!
    
    
    @IBOutlet weak var textAuthorLabel: UILabel!

    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var likesButton: UIButton!
    
    @IBOutlet weak var popoverButton: UIButton!
    
    @IBOutlet weak var flagButton: UIButton!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet weak var authorProfileImage: UIImageView!
    
    var key: String!
    
    var showCommentsAction: ((UITableViewCell) -> Void)?
    var showLikesAction: ((UITableViewCell) -> Void)?
    var showPopover:((UITableViewCell) -> Void)?
    
    var feed: Feed? {
        didSet{
            if let feed = feed {
                textFeedLabel.text = feed.text
                textAuthorLabel.text = feed.author
                feedImage.clipsToBounds = true
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
    
    @IBAction func didTappedPopover(sender: AnyObject) {
        showPopover?(self)
    }

    @IBAction func didTappedComments(sender: AnyObject) {
        showCommentsAction?(self)
    }

    @IBAction func didTappedLikeAction(sender: AnyObject) {
        likesButton.enabled = false
        
        likesLabel.text = String(UInt(likesLabel.text!)! + 1)

        
        showLikesAction?(self)
    }

}
