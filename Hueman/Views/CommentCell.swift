//
//  CommentCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/26/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation
import FirebaseStorage


import UIKit


class CommentCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var commentText: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    
    var cachedImages = NSCache()
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var comment: Comment? {
        didSet {
            if let comment = comment {
                self.name.text = comment.name
                self.commentText.text = comment.text
                
                if let cachedImage = self.cachedImages.objectForKey(comment.imageURL) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.authorImage.image = cachedImage as? UIImage
                        
                    })
                } else {
                    storageRef.referenceForURL(comment.imageURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            
                            if let imageData = data {
                                let feedImage = UIImage(data: imageData)
                                self.cachedImages.setObject(feedImage!, forKey:comment.imageURL)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.authorImage.image = feedImage
                                    
                                })
                            }
                            
                        }else {
                            print(error!.localizedDescription)
                        }
                    })
                }
                


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
