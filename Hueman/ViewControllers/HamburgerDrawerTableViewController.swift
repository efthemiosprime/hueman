//
//  HamburgerDrawerTableViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HamburgerDrawerTableViewController: UITableViewController {
    
    @IBOutlet var profileImage: UIImageView!
    
    var userRef: FIRDatabaseQuery!
    var currentUser: User!
    

    let cachedProfileImage = NSCache()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    
    var storageRef: FIRStorage!{
        return FIRStorage.storage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef = FIRDatabase.database().reference().child("users").queryOrderedByChild("email").queryEqualToValue(FIRAuth.auth()!.currentUser!.email)
        
        
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.UIColorFromRGB(0x666666).CGColor

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       // let userRef = dataBaseRef.child("users").queryOrderedByChild("email").queryEqualToValue(FIRAuth.auth()!.currentUser!.email)
        
    }
    
    


    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

        if self.currentUser == nil {
            
            userRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                for userInfo in snapshot.children {
                    
                    self.currentUser = User(snapshot: userInfo as! FIRDataSnapshot)
                    
                }
                
                if let profileCell = cell as? DrawerProfileImageRowCell {
                    profileCell.profileImage.clipsToBounds = true
                    profileCell.profileImage.layer.cornerRadius = 61
                    profileCell.profileImage.contentMode = .ScaleToFill
                    
                    if let profileImageURL = self.currentUser.photoURL {
                        if let cachedImage = self.cachedProfileImage.objectForKey(profileImageURL) {
                            profileCell.profileImage.image = cachedImage as? UIImage
                        } else {
                            self.storageRef.referenceForURL(profileImageURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                                if error == nil {
                                    if let imageData = data {
                                        let image = UIImage(data: imageData)
                                        self.cachedProfileImage.setObject(image!, forKey: profileImageURL)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            profileCell.profileImage.image = image
                                            
                                        })
                                    }

                                    
                    
                                }else {
                                    print(error!.localizedDescription)
                                }
                            })
                        }
                    }
                    
                    
                    

                    
                    
                }
                
                if let nameCell = cell as? DrawerProfileNameRowCell {
                    nameCell.nameLabel.text = self.currentUser.name
                    
                }

                
                
                
                
            }) { (error) in
                print(error.localizedDescription)
                
            }
            

            

            
            
        }
        

        return cell
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        print(indexPath.row)
        if indexPath.row == 9 {
            
            
            userRef.removeAllObservers()
            
            do {
                
                try FIRAuth.auth()?.signOut()
                
                if FIRAuth.auth()?.currentUser == nil {
                    let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                    if hasLogin {
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
                        NSUserDefaults.standardUserDefaults().setValue(nil, forKeyPath: "email")
                        NSUserDefaults.standardUserDefaults().synchronize() 
                    }
                    
                    let keychainWrapper = KeychainWrapper()
                    let vData = keychainWrapper.myObjectForKey("v_Data");
                    if (!(vData as? String)!.isEmpty) || vData == nil {
                        keychainWrapper.mySetObject(nil, forKey:"v_Data")
                        keychainWrapper.writeToKeychain()

                    }

                }
                self.dismissViewControllerAnimated(true, completion: nil)

                
            } catch let error as NSError {
                print("sign out " + error.localizedDescription)
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if indexPath == 2 || indexPath == 8 {
            cell.selectionStyle = .None
           // return nil
        }
        
        return indexPath
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
