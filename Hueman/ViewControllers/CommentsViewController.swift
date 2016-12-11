//
//  CommentsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/11/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {
    
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.topItem!.title = "comments"
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.navigationBar.topItem!.title = "comments"
            

            
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)

        }
        
        
        
        // MARK: - Table View
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath)
            
            
            return cell
        }
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 90
        }
    @IBAction func didTappedDismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
