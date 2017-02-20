//
//  ProfileViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/12/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftOverlays

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet var hues: [ProfileHue]?
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var user: User?
    
    let cachedProfileImage = NSCache()
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x999999).CGColor
        profileImage.contentMode = .ScaleAspectFill

        
        var topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]
        for (index, hue) in hues!.enumerate() {
            hue.type = topics[index]
        }
        
        if let unwrappedUser = user {
            getCurrentProfile(unwrappedUser)
        }
        


        
        self.view.layer.masksToBounds = false
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        self.view.layer.shadowOpacity = 0.5
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,
            NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)
        ]
        
        self.navigationBar.topItem?.title = user!.name

        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight)
            
            
        }) { (Finished) -> Void in
            
        }

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        self.view.layer.masksToBounds = false
//        self.view.layer.shadowColor = UIColor.blackColor().CGColor
//        self.view.layer.shadowOffset = CGSizeMake(0.0, 5.0)
//        self.view.layer.shadowOpacity = 0.5
//      //  self.view.layer.shadowPath = shadowPath.CGPath
//    }
//    


    @IBAction func backActionHandler(sender: AnyObject) {
       // self.dismissViewControllerAnimated(true, completion: {})
       // self.performSegueWithIdentifier("UnwindSegue", sender: self)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
     //   CGRectOffset(<#T##rect: CGRect##CGRect#>, CGFloat, <#T##dy: CGFloat##CGFloat#>)
//        self.view.layer.backgroundColor = UIColor.clearColor().CGColor
//        self.view.backgroundColor = UIColor.clearColor()

        // Animate the transition.
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectOffset(self.view.frame, screenWidth, 0.0)
            
        }) { (Finished) -> Void in
        
            self.remove()
        }

    }
    
    func remove() {
        self.willMoveToParentViewController(nil)
        self.didMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    func getCurrentProfile(_user: User) {
       // self.navigationBar.topItem!.title = _user.name
        self.birthdayLabel.text = _user.birthday
        self.cityLabel.text = _user.location
        self.bioLabel.text = _user.bio
        
        if let unwrappedPhotoURL = _user.photoURL {
            
            if let cachedImage = self.cachedProfileImage.objectForKey(unwrappedPhotoURL) {
                self.profileImage.image = cachedImage as? UIImage
                
            }else {
                storageRef.referenceForURL(unwrappedPhotoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                    if error == nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedProfileImage.setObject(image!, forKey: unwrappedPhotoURL)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.profileImage.image = image
                                
                            })
                        }
                    }else {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
        
        // todo: 
        let huesRef = dataBaseRef.child("users").child(_user.uid).child("hues")
        huesRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            
            if snapshot.exists() {
                // TODO: to refactor iterate?
                if let wanderlust = snapshot.value![Topic.Wanderlust]  {
                    if let unWrappedDetail = wanderlust  {
                        self.hues![0].data = ProfileHueModel(title: "I would love to visit", description: unWrappedDetail as! String, type: Topic.Wanderlust)
                    }
                }
                
                if let food = snapshot.value![Topic.OnMyPlate]  {
                    if let detail = food  {
                        self.hues![1].data = ProfileHueModel(title: "I love to stuff myself with", description: detail as! String, type: Topic.OnMyPlate)
                    }
                }
                
                
                if let snap = snapshot.value![Topic.RelationshipMusing]  {
                    if let detail = snap  {
                        self.hues![2].data = ProfileHueModel(title: "I cherish my relationship with", description: detail as! String, type: Topic.RelationshipMusing)
                    }
                }
                
                if let snap = snapshot.value![Topic.Health]  {
                    if let detail = snap  {
                        self.hues![3].data = ProfileHueModel(title: "I keep health / fit by", description: detail as! String, type: Topic.Health)
                    }
                }
                
                if let snap = snapshot.value![Topic.DailyHustle]  {
                    if let detail = snap  {
                        self.hues![4].data = ProfileHueModel(title: "I am a", description: detail as! String, type: Topic.DailyHustle)
                    }
                }
                if let snap = snapshot.value![Topic.RayOfLight]  {
                    if let detail = snap  {
                        self.hues![5].data = ProfileHueModel(title: "What makes you smile?", description: detail as! String, type: Topic.RayOfLight)
                    }
                }
      
            }
        })
       

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
