//
//  AddConnectionsController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/15/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class AddConnectionsController: UITableViewController {
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    var currentUser: User?
    
    var users = [User]()
    var requests = [User]()
    var connections = [Connection]()
    
    var sections = [String]()
    var data: [[User]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: Font.SofiaProRegular, size: 20)!]

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 96
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)]
        
        if currentUser == nil {
            currentUser = AuthenticationManager.sharedInstance.currentUser
        }
        
        fetchConnections()
        
//        if let unwrappedUID = currentUser?.uid {
//            let userRef = databaseRef.child("users").child(unwrappedUID)
//            userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//                
//                if snapshot.exists() {
//                   / self.currentUser = User(snapshot: snapshot)
//                    self.fetchConnections()
//                }
//                
//                
//            }) { error in
//                print(error.localizedDescription)
//            }
//        }
//        

        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.users.removeAll()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func fetchAllUsers() {
        
        let userRef = databaseRef.child("users")
    

        userRef.observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            
            if snapshot.exists() {
                
                let connectionsUids: [String] = self.connections.map({$0.uid})
                let requestsUids: [String] = self.requests.map({$0.uid})
                self.users = snapshot.children.map({(snap) -> User in
                    let newUser: User = User(snapshot: snap as! FIRDataSnapshot)
                    return newUser
                })
                .filter({ !connectionsUids.contains($0.uid) })
                .filter({ $0.uid != self.currentUser!.uid} )
                .filter({ !requestsUids.contains($0.uid) })
                .sort({ (user1, user2) -> Bool in
                    user1.name < user2.name
                })
                

                
                if self.requests.count > 0 {
                    self.sections.append("pending")
                    self.data.append(self.requests)
                    
                    self.sections.append("users")
                    self.data.append(self.users)
                }else {
                    self.data.append(self.users)
                    self.sections.append("users")


                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                
            }
            
            


        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllRequests() {
        
        if let unwrappedUID = currentUser?.uid {
            let requestRef = databaseRef.child("requests").child(unwrappedUID)
            
            requestRef.observeSingleEventOfType(.Value, withBlock:{
                snapshot in
                if snapshot.exists() {
                    
                    
                    for snap in snapshot.children {
                        if let requester = snap.value!["requester"] as? String {
                            let requestFromRef = self.databaseRef.child("/users/\(requester)")
                            
                            requestFromRef.observeSingleEventOfType(.Value, withBlock: {userSnap in
                                
                                let userRequest = User(snapshot: userSnap )
                                self.requests.append(userRequest)
                            }) {(error ) in
                                print(error.localizedDescription)
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
                self.fetchAllUsers()
                
            }) {(error) in
                print(error.localizedDescription)
            }
        }

    }
    
    func fetchConnections() {
        if let unwrappedUID = currentUser?.uid {
            print("uid \(unwrappedUID)")
            let friendsRef = databaseRef.child("friends").child(unwrappedUID)
            
            friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    for con in snapshot.children {
                       let connection = Connection(name: (con.value!["name"] as? String)!,
                            location: (con.value!["location"] as? String)!, imageURL: (con.value!["imageURL"] as? String)!, uid: (con.value!["uid"] as? String)!, friendship: (con.value!["friendship"] as? String)!)
                       self.connections.append(connection)
                    }
                }
                
               self.fetchAllRequests()
                
                
            }) {(error) in
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! AddUserCell
        

        currentCell.user = data[indexPath.section][indexPath.row]
        
        
        if let photoURL = currentCell.user?.photoURL where !(currentCell.user?.photoURL?.isEmpty)! {
            storageRef.referenceForURL(photoURL).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let data = data {
                            currentCell.connectionImage.image = UIImage(data: data)
                        }
                    })
                    
                    
                }else {
                    print(error!.localizedDescription)
                }
            })
        }

        

        if indexPath.section == 0 && sections.count > 1 {
            // accept request
            currentCell.addUserAction = { (cell) in
                

                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.data[0].removeAtIndex(indexPath.row)
                
                
                let requestRef = self.databaseRef.child("requests").child((self.currentUser?.uid)!)
                requestRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if snapshot.exists() {
                        
                        if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            
                            
                            
                            for child in result {
                                
                                let friendshipKey = child.value!["id"] as! String
                                let friendshipRequester = child.value!["requester"] as! String
                                let friendshipRecipient = child.value!["recipient"] as! String
                                let friendshipRef = self.databaseRef.child("friendships").child(friendshipKey)
                                
                                friendshipRef.updateChildValues(["status":Friendship.Accepted])
                                
                                // friendshipRecipient == currentUserUid
                                // Recipient is the current user
                                
                                
                                let userRef = self.databaseRef.child("users").child(friendshipRequester)
                                userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                                    if snapshot.exists() {
                                        var requester = Connection(snapshot: snapshot)
                                        requester.friendship = friendshipKey
                                        
                                        var recipient = Connection(name: self.currentUser!.name, location: self.currentUser!.location!.location!, imageURL: self.currentUser!.photoURL!, uid: self.currentUser!.uid)
                                        recipient.friendship = friendshipKey
                                        
                                        
                                        self.databaseRef.child("friends").child(friendshipRequester).child(recipient.uid).setValue(recipient.toAnyObject())
                                        self.databaseRef.child("friends").child(friendshipRecipient).child(requester.uid).setValue(requester.toAnyObject())
                                        
                                    }
                                }) { error in
                                    print(error.localizedDescription)
                                }
                                
                            }
                            
                            requestRef.removeValue()
                            
                        
                    }
                    

                    } else {
                        print("no results")
                    }
                    
                    
                }) {(error) in
                    
                    print(error.localizedDescription)
                }
                
                
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
            }
        }else {
            // make request user
            currentCell.addUserAction = { (cell) in
                
                let requestId = NSUUID().UUIDString
                let connectionRequest = Request(from: self.currentUser!.uid, to: currentCell.user!.uid, id: requestId)
                let requestRef = self.databaseRef.child("requests").child(connectionRequest.recipient!).child(connectionRequest.id!)


//                self.tableView.beginUpdates()
//                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                self.data[indexPath.section].removeAtIndex(indexPath.row)
//                
//                self.tableView.reloadData()
//                self.tableView.endUpdates()
                
                requestRef.setValue(connectionRequest.toAnyObject(), withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        //feedPosted?()
                        
                        let friendshipsReq = self.databaseRef.child("friendships").child(requestId)
                        let friendships = Friendship(from: connectionRequest.requester!, to: connectionRequest.recipient!, id: connectionRequest.id!, status: Friendship.Pending)
                        friendshipsReq.setValue(friendships.toAnyObject(), withCompletionBlock: {
                            (error, ref) in
                            currentCell.added()
                        })
                    }
                })
                
            }
        }

        
        return currentCell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AddUserCell {
            
                    let screenWidth = UIScreen.mainScreen().bounds.size.width
                    let screenHeight = UIScreen.mainScreen().bounds.size.height
            
                    if let unwrappedUid = cell.user?.uid {
            
                        let userRef = databaseRef.child("users").child(unwrappedUid )
                        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if snapshot.exists() {
                                
                                
                                var profileViewIsPresent = false
                                
                                
                                if let viewControllers = self.tabBarController?.parentViewController?.childViewControllers {
                                    for viewController in viewControllers {
                                        if(viewController is ProfileViewController) {
                                            profileViewIsPresent = true
                                            continue
                                        }
                                    }
                                }
                                
                                if profileViewIsPresent == false {
                                    
                                    let user = User(snapshot: snapshot)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
                                        profileController?.user = user
                                        
                                        
                                        self.tabBarController?.parentViewController!.addChildViewController(profileController!)
                                        profileController?.view.frame =  CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
                                        self.tabBarController?.parentViewController!.view.addSubview((profileController?.view)!)
                                        profileController!.didMoveToParentViewController(self.tabBarController?.parentViewController)
                                        
                                    })
                                }

                            }
                            
                        })
                        
                    }
        }

        


    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.data.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.UIColorFromRGB(0x666666)
        
        let title = UILabel()
        title.font = UIFont(name: Font.SofiaProRegular, size: 12)!
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
    }
    
//    override func setEditing(editing: Bool, animated: Bool) {
//        super.setEditing(true, animated: true)
//    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
