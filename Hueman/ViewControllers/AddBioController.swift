//
//  AddBioController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddBioController: UIViewController {

    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bioInput: UITextView!
    
    @IBOutlet weak var bioInputConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var keyboardConstraintHeight: NSLayoutConstraint!
    
    let SKIP_LABEL = "maybe later"
    let NEXT_LABEL = "next"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSkip()

    }


    
    @IBAction func backAction(sender: AnyObject) {
    }

}


extension AddBioController {
    func buttonNext() {
        nextButton.layer.borderWidth = 0
        nextButton.backgroundColor = UIColor.UIColorFromRGB(0x666666)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton.setTitle(NEXT_LABEL, forState: .Normal)

    }
    
    func buttonSkip() {
        nextButton.layer.borderWidth = 1
        nextButton.setTitle(SKIP_LABEL, forState: .Normal)
        nextButton.setTitleColor(UIColor(rgb: 0xffffff, alphaVal: 0.4), forState: .Normal)
        nextButton.layer.borderColor = UIColor(rgb: 0xffffff, alphaVal: 0.4).CGColor
        nextButton.tintColor = UIColor.UIColorFromRGB(0x666666)
        nextButton.backgroundColor = UIColor.clearColor()
    }
}
