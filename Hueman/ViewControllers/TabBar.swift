//
//  TabBar.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class TabBar: UITabBarController, UITabBarControllerDelegate{

    @IBOutlet weak var writePostItem: UIBarButtonItem!
   // @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarBackground = UIImage(named: "tabbar-bg.png")
        self.tabBar.backgroundImage = tabBarBackground
        self.tabBar.shadowImage = UIImage()

        self.tabBar.layer.shadowOffset = CGSizeMake(0, 0)
        self.tabBar.layer.shadowRadius = 6
        self.tabBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.tabBar.layer.shadowOpacity = 0.3

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,
            NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x959595)
        ]
        
        self.delegate = self
        
        
    }
    

    
    @IBAction func createFeed(sender: AnyObject) {
        createPost()
    }
    
    func showProfile() {
        self.performSegueWithIdentifier("ShowProfile", sender: nil)
    }

    func createPost() {
        self.performSegueWithIdentifier("CreatePost", sender: nil)

    }
    
    func filterOption() {
        self.performSegueWithIdentifier("FilterOption", sender: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print (tabBarController.selectedIndex)
        
        if viewController == tabBarController.viewControllers![3]    {
            print("xx HueboardsViewController xx")
            return false

        }

        return true
    }

}
