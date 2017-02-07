//
//  ConnectionProfileViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/29/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class ConnectionProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = 232/2

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,
            NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0x999999)
        ]
        
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillAppear(animated)
       self.navigationController?.navigationBarHidden = false
        
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
