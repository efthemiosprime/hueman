//
//  TabBar.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    @IBOutlet weak var profileItem: UIBarButtonItem!
    @IBOutlet weak var writePostItem: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
            NSForegroundColorAttributeName : UIColorFromRGB(0x959595)
        ]
        
        let circular = UIColor(patternImage: UIImage(named:"profile-bar-item")!)
        let itemView = UIView(frame: CGRectMake(0, 0, 22, 22))
        itemView.backgroundColor = circular
        let profieImage = UIImage(named: "hulyo.jpg")
        
        let profileImageButtonItem = UIButton(type: .Custom)
        profileImageButtonItem.frame = CGRectMake(0, 0, 17, 17)
        profileImageButtonItem.center = itemView.center
        profileImageButtonItem.setImage(profieImage, forState: .Normal)
        profileImageButtonItem.contentMode = .ScaleAspectFit
        profileImageButtonItem.layer.cornerRadius = 8.5
        profileImageButtonItem.clipsToBounds = true
        profileImageButtonItem.addTarget(self, action: #selector(TabBar.showProfile), forControlEvents: .TouchUpInside)
        itemView.addSubview(profileImageButtonItem)
        
        profileItem!.customView = itemView

        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showProfile() {
        self.performSegueWithIdentifier("ShowProfile", sender: nil)
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
