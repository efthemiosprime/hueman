//
//  OnboardingController.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/23/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
protocol OnboardingDelegate {
    func gotoNextPage(index: Int)
    func getTotalPage() -> Int
}

class OnboardingController: UIViewController {

    @IBOutlet weak var welcomeHeaderImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    
    var index:Int = 0
    
    var data: Onboarding?
    
    var delegate: OnboardingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonNext()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backgroundImage.contentMode = .ScaleAspectFill

        welcomeHeaderImage.hidden = index > 0
        backgroundImage.image = UIImage(named: (data?.background)!)
        onboardingImage.image = UIImage(named: (data?.imageName)!)
        descriptionLabel.text = data?.description
        titleLabel.text = data?.title
        
    }

    @IBAction func nextButtonAction(sender: AnyObject) {
        if index == (self.delegate?.getTotalPage())! - 1 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "firstTime")
            defaults.synchronize()
            
            self.performSegueWithIdentifier("gotoWelcome", sender: nil)
        }else {
            self.delegate?.gotoNextPage(index)

        }
    }
}


extension OnboardingController {
    func buttonNext() {
        nextButton.layer.borderWidth = 1
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.setTitleColor(UIColor.UIColorFromRGB(0x666666), forState: .Normal)
        nextButton.tintColor = UIColor.UIColorFromRGB(0xffffff)
        nextButton.setTitle("next", forState: .Normal)
        nextButton.setTitleColor(UIColor(rgb: 0xffffff, alphaVal: 0.4), forState: .Normal)
        nextButton.layer.borderColor = UIColor(rgb: 0xffffff, alphaVal: 0.4).CGColor
        nextButton.enabled = true
        
    }
    


}


