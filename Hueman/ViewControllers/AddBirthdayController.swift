//
//  AddBirthdayController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/27/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddBirthdayController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var backButton: UIButton!
    
    
//    var delegate: BirthdayDelegate?
    var entry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visibilitySwitch.on = false
        visibilitySwitch.tintColor = UIColor.whiteColor()
        visibilitySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        //visibilitySwitch.backgroundColor = UIColor.whiteColor()
        
        
        
        datePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        
        
        
        if let unwrappedEntry = entry {
            let dateString = unwrappedEntry
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM dd yyyy"
            let dateObj = dateFormatter.dateFromString(dateString)
            
            
            datePicker.date = dateObj!
            
            
        }
        
        disableNext()
        
        datePicker.addTarget(self, action: #selector(AddBirthdayController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    
    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
     
        //self.delegate?.pickerDidChange(dateFormatter.stringFromDate(sender.date))
        SignupManager.sharedInstance.userBirthday = UserBirthday(date: dateFormatter.stringFromDate(sender.date))
        
        enableNext()
        
    }
    
    

    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("backToAddName", sender: self)
    }

    @IBAction func nextAction(sender: AnyObject) {
        SignupManager.sharedInstance.userBirthday?.visible = visibilitySwitch.on

        self.performSegueWithIdentifier("gotoAddLocation", sender: self)
    }
    
    @IBAction func backToAddBirthday(segue: UIStoryboardSegue) {}

}


extension AddBirthdayController {
    func disableNext() {
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.tintColor = UIColor.UIColorFromRGB(0xf49445)
        nextButton.enabled = false
    }
    
    func enableNext() {
        nextButton.layer.borderWidth = 0
        nextButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.tintColor = UIColor.UIColorFromRGB(0xf49445)
        nextButton.enabled = true
        
    }
    
}
