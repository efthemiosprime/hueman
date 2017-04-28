//
//  InterstitialController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class InterstitialController: UIViewController {

    @IBOutlet weak var profileButton: RoundedCornersButton!
    @IBOutlet weak var exploreButton: RoundedCornersButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        enableButton(profileButton, label: "continue with profile")
        disableButton(exploreButton, label: "start exploring hueman")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        defaults.setBool(false, forKey: "firstTime")
        defaults.synchronize()

    }


    @IBAction func editProfileAction(sender: AnyObject) {
        AuthenticationManager.sharedInstance.loadCurrentUser({
            self.performSegueWithIdentifier("continueWithProfile", sender: nil)
        })
        
    }
    
    @IBAction func exploreAction(sender: AnyObject) {
        AuthenticationManager.sharedInstance.loadCurrentUser({
            self.performSegueWithIdentifier("gotoExplore", sender: nil)

        })
    }
    
}


extension InterstitialController {
    func enableButton(btn: RoundedCornersButton, label: String) {
        btn.layer.borderWidth = 0
        btn.backgroundColor = UIColor.whiteColor()
        btn.setTitleColor(UIColor.UIColorFromRGB(0x33b5d3), forState: .Normal)
        btn.setTitle(label, forState: .Normal)
        
    }
        
    func disableButton(btn: RoundedCornersButton, label: String) {
        btn.layer.borderWidth = 1
        btn.setTitle(label, forState: .Normal)
        btn.setTitleColor(UIColor(rgb: 0xffffff, alphaVal: 1), forState: .Normal)
        btn.layer.borderColor = UIColor(rgb: 0xffffff, alphaVal: 1).CGColor
        btn.backgroundColor = UIColor.clearColor()
    }
    
}
