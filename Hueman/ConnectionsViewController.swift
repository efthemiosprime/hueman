//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    
    var connections = [Profile]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem!.title = "connections"
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
        connections.append(Profile(name:"Julius Busa", image: "hulyo.jpg", topic: .RelationshipMusing))
        connections.append(Profile(name:"Maverick Shawn Aquino", image: "hulyo.jpg", topic: .OnMyPlate))
        connections.append(Profile(name:"Nicolette Onate", image: "hulyo.jpg", topic: .DailyHustle))
        connections.append(Profile(name:"Camille Laurente", image: "hulyo.jpg", topic: .Health))
        connections.append(Profile(name:"Efthemios Suyat", image: "hulyo.jpg", topic: .RayOfLight))
        
        
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let searchBoxController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchBox") as UIViewController
        searchBoxController.view.frame = CGRectMake(0, 0, searchView.frame.size.width, 75)
        self.searchView.addSubview(searchBoxController.view)
        
    }
    
    // MARK: - Table View

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationProfileController = segue.destinationViewController as? ConnectionProfileViewController {
            
        }
    }
    
    
}


extension ConnectionsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = indexPath.row % 2 == 0 ? tableView.dequeueReusableCellWithIdentifier("ConnectionLeftCell", forIndexPath: indexPath) as! ConnectionLeftCell : tableView.dequeueReusableCellWithIdentifier("ConnectionRightCell", forIndexPath: indexPath) as! ConnectionRightCell
        
        
        cell.backgroundColor = UIColor.clearColor()
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        
        if let leftCell = cell as? ConnectionLeftCell {
            leftCell.profile = connections[indexPath.row]
        }
        
        if let rightCell = cell as? ConnectionRightCell {
            rightCell.profile = connections[indexPath.row]
            
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        performSegueWithIdentifier("showConnection", sender: indexPath)
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.selected == true {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension ConnectionsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
}
