//
//  ConnectionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.navigationController?.navigationBar.
        
        let connections : [Profile] = [
            Profile(name: "Julius\nBusa", topic: .RelationshipMusing),
            Profile(name: "Maverick Shawn\nAquino", topic: .OnMyPlate),
            Profile(name: "Nicolette\nOñate", topic: .DailyHustle),
            Profile(name: "Camille\nLaurente", topic: .RayOfLight),
            Profile(name: "Julius\nBusa", topic: .RelationshipMusing),
            Profile(name: "Maverick Shawn\nAquino", topic: .Wanderlust),
            Profile(name: "Nicolette\nOñate", topic: .Health),
            Profile(name: "Camille\nLaurente", topic: .RayOfLight)
        ]
        
    
        let connectionWidth: CGFloat = 200
        let connectionHeight: CGFloat = 128
        let connectionPadding: CGFloat = -25
        var yOffset: CGFloat = 25
        var xOffset: CGFloat = 65
        var scrollViewContentSize: CGFloat = 0
        var index = 0
        var type = 0
        for connectionItem in connections {
            
            if index % 2 == 0 {
                type = 1
                xOffset = 45
            }else {
                type = 2
                xOffset = connectionWidth - 45
            }
            
            let connection = Connection(name: connectionItem.name!, hue: connectionItem.topic!, direction: type)
            connection.connectionName = connectionItem.name!
            connection.hue = connectionItem.topic!
            connection.direction = type
            
            connection.frame = CGRectMake(xOffset, yOffset, connectionWidth, connectionHeight)
            
            self.scrollView.addSubview(connection)
            
            yOffset += (connectionHeight + connectionPadding)
            scrollViewContentSize += connectionHeight
            index += 1
            scrollView.contentSize = CGSize(width: connectionWidth, height: scrollViewContentSize)
        }
        

                let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action:("addTapped"))
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "connections"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
