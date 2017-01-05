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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBar.showProfile), name:"ShowProfile", object: nil)

        
    }


    
    @IBAction func createFeed(sender: AnyObject) {
        createPost()
    }
    
    func showProfile() {
        print("showing....")

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        print(self.parentViewController?.childViewControllers.count)

        if self.parentViewController?.childViewControllers.count < 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileView") as? ProfileViewController
            profileController?.user = AuthenticationManager.sharedInstance.currentUser

            
            self.parentViewController!.addChildViewController(profileController!)
            profileController?.view.frame =  CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
            self.parentViewController?.view.addSubview((profileController?.view)!)
            profileController!.didMoveToParentViewController(self.parentViewController)
        }

    }

    func createPost() {
        self.performSegueWithIdentifier("CreatePost", sender: nil)

    }
    
    func filterOption() {
        self.performSegueWithIdentifier("FilterOption", sender: nil)


    }
    // MARK: - Navigation

    

    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print (tabBarController.selectedIndex)
        
        if viewController == tabBarController.viewControllers![3]    {
            createPost()
            return false

        }

        return true
    }

}
