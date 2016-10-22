//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionsViewController: UITableViewController {
    
    var connections = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem!.title = "connections"
        self.tableView.separatorStyle = .None
        self.tableView.allowsSelection = false
        
        connections.append(Profile(name:"Julius\nBusa", topic: .RelationshipMusing))
        connections.append(Profile(name:"Maverick Shawn\nAquino", topic: .OnMyPlate))
        connections.append(Profile(name:"Nicolette\nOnate", topic: .DailyHustle))
        connections.append(Profile(name:"Camille\nLaurente", topic: .Health))
        connections.append(Profile(name:"Efthemios\nSuyat", topic: .RayOfLight))

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
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
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145
    }
}
