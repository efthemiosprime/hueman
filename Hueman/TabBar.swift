//
//  TabBar.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       let tabBarBackground = UIImage(named: "tabbar-bg")
        self.tabBar.backgroundImage = tabBarBackground
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.clearColor().CGColor
        self.tabBar.clipsToBounds = true
        
        
       // self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!]
      //  self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColorFromRGB(0x999999)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("xxx")
        item.enabled=true
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
