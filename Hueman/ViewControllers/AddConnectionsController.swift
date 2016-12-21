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
    
    var users = [User]()
    var requests = [User]()
    
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
        
        //self.tableView.setEditing(true, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
//        self.navigationBar.topItem!.title = ""
        self.navigationController?.navigationBar.translucent = false
//        self.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)]
        
        
        fetchAllRequests()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func fetchAllUsers() {
        
        print("fetchAllUsers")
        let userRef = databaseRef.child("users")
    
        let currentUser = FIRAuth.auth()?.currentUser

        userRef.observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            
            var allUsers = [User]()
            for snap in snapshot.children {
                let newUser = User(snapshot: snap as! FIRDataSnapshot )
                if currentUser?.uid != newUser.uid {
                    allUsers.append(newUser)
                }
            }
            
            self.users = allUsers.sort({ (user1, user2) -> Bool in
                    user1.name < user2.name
            })
            

            if self.requests.count > 0 {
                self.sections.append("pending")
                self.data.append(self.requests)
                
                self.sections.append("users")
                self.data.append(self.users)
            }else {
                self.sections.append("users")
                self.data.append(self.users)
            }

            self.tableView.reloadData()

        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllRequests() {
        let currentUser = FIRAuth.auth()?.currentUser
        let requestRef = databaseRef.child("requests").child((currentUser?.uid)!)

        requestRef.observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            if snapshot.exists() {
                

                
                for snap in snapshot.children {
                    if let from = snap.value!["from"] as? String {
                        print("from \(from)")
                        let requestFromRef = self.databaseRef.child("/users/\(from)")
                        
                        requestFromRef.observeSingleEventOfType(.Value, withBlock: {userSnap in
                            
                            let userRequest = User(snapshot: userSnap )
                            self.requests.append(userRequest)
                        }) {(error ) in
                            print(error.localizedDescription)
                            
                        }
                        

                    }
                }


                self.fetchAllUsers()

            }else {

                self.fetchAllUsers()
            }

            
        }) {(error) in
            print(error.localizedDescription)
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
        
        
        storageRef.referenceForURL((currentCell.user?.photoURL)!).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
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
        
        let currentUser = FIRAuth.auth()?.currentUser
        let currentUserUid = currentUser!.uid

        if indexPath.section == 0 && sections.count > 1 {
            // accept request
            currentCell.addUserAction = { (cell) in
                

                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.data[0].removeAtIndex(indexPath.row)
                self.tableView.reloadData()
                self.tableView.endUpdates()
                
                let requestRef = self.databaseRef.child("requests").child(currentUserUid)
                requestRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        

                        
                        for child in result {

                            let friendshipKey = child.value!["id"] as! String
                            let friendshipFrom = child.value!["from"] as! String
                            let friendshipTo = child.value!["to"] as! String
                            let friendshipRef = self.databaseRef.child("friendships").child(friendshipKey)
                            
                            friendshipRef.updateChildValues(["status":Friendship.Accepted])
                            cell.addButton.userInteractionEnabled = false
                            cell.addButton.hidden = true






                            
                            /// friendshipTo == currentUserUid
                            
                        //    self.databaseRef.child("friends").child(friendshipFrom).setValue(friendshipTo)
                        //    self.databaseRef.child("friends").child(friendshipTo).setValue(friendshipFrom)
                            
                            

                        }
                        
                        
                    } else {
                        print("no results")
                    }
                    
                    
                }) {(error) in
                    
                    print(error.localizedDescription)
                }

                
            }
        }else {
            // add user
            currentCell.addUserAction = { (cell) in
                
                let requestId = NSUUID().UUIDString
                let connectionRequest = Request(from: currentUserUid, to: currentCell.user!.uid, id: requestId)
                let requestRef = self.databaseRef.child("requests").child(connectionRequest.recipient!).child(connectionRequest.id!)
                
                requestRef.setValue(connectionRequest.toAnyObject(), withCompletionBlock: {
                    (error, ref) in
                    if error == nil {
                        //feedPosted?()
                      //  print("posted")
                        
                        let friendshipsReq = self.databaseRef.child("friendships").child(requestId)
                        let friendships = Friendship(from: connectionRequest.requester!, to: connectionRequest.recipient!, id: connectionRequest.id!, status: Friendship.Pending)
                        friendshipsReq.setValue(friendships.toAnyObject(), withCompletionBlock: {
                            (error, ref) in
                            
                            print("posted \(ref)")
                        })
                    }
                })
                
            }
        }

        
        return currentCell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections[section]
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
//    override func setEditing(editing: Bool, animated: Bool) {
//        super.setEditing(true, animated: true)
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var pendingRequest = self.data[indexPath.section]
            pendingRequest.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    

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
