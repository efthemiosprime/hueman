//
//  UserCell.swift
//  Hueman
//
//  Created by Efthemios Suyat on 12/16/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AddUserCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var connectionImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    
    
    var addUserAction: ((AddUserCell) -> Void)?
    var friendship: Friendship?

    var user: User? {
        didSet {
            if let user = user {
                nameLabel.text = user.name
                locationLabel.text = user.location
                connectionImage.clipsToBounds = true
                
                
                getPendingRequest({
                    if let userUid = user.uid {
                        
                        if self.recipientsUIDs.contains(userUid) {
                            self.pendingButton.hidden = false
                            self.addButton.hidden = true
                            self.addButton.enabled = false
                        }else {
                            self.pendingButton.hidden = true
                            self.addButton.hidden = false
                            self.addButton.enabled = true
                        }

                    }
                })
            }
        }
    }
    
    var recipientsUIDs: [String] = [String]()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pendingButton.hidden = true
        let screenSize = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        if screenHeight <= 568 {
            let nameRectSize = nameLabel.frame
            nameLabel.frame.size = CGSizeMake(150, nameRectSize.height)
            nameLabel.adjustsFontSizeToFitWidth = true
            
            let locRectSize = locationLabel.frame.size
            locationLabel.frame.size = CGSizeMake(150, locRectSize.height)
            locationLabel.adjustsFontSizeToFitWidth = true

            
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getPendingRequest(completion: (() -> ())? = nil) {
        let currentUser = AuthenticationManager.sharedInstance.currentUser
        if let uid = currentUser?.uid {
            let friendshipRef = databaseRef.child("friendships").queryOrderedByChild("requester").queryEqualToValue(uid)

            friendshipRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    
                    let friendship = snapshot.children.map({ (snap) -> Friendship in
                        let newFriendship = Friendship(snapshot: snap as! FIRDataSnapshot)
                        return newFriendship
                    })
                    .filter({ $0.status == "Pending"})
                    
                    self.recipientsUIDs = friendship.map ( { return $0.recipient!  } )
                    completion?()
 
                }

            })
        }

    }
    
    
    func added() {
        self.pendingButton.hidden = false
        self.addButton.hidden = true
        self.addButton.enabled = false
    }
    
    @IBAction func didTappedAddUser(sender: AnyObject) {
        if pendingButton.hidden == false {
            return
        }
        
        addUserAction?(self)
    }
    
}
