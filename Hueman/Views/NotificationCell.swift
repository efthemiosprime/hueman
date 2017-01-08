//
//  NotificationCell.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseStorage

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationTimestampLabel: UILabel!
   
    @IBOutlet weak var profileImage: UIImageView!
    
    var key: String!
    
    var cachedImages = NSCache()

    
    var data: NotificationItem? {
        didSet {
            if let notification = data {
                notificationLabel.text = "\(notification.name) \(notification.type) on your post."
                notificationTimestampLabel.text = notification.dateCreated ?? ""
                
                
                if let cachedImage = self.cachedImages.objectForKey(notification.photoURL) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profileImage.image = cachedImage as? UIImage
                        
                    })
                } else {
                    storageRef.referenceForURL(notification.photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                        if error == nil {
                            
                            if let imageData = data {
                                let photoImage = UIImage(data: imageData)
                                self.cachedImages.setObject(photoImage!, forKey:notification.photoURL)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.profileImage.image = photoImage
                                    
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
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x959595).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
