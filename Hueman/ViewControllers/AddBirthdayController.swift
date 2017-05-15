//
//  AddBirthdayController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/27/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
protocol AddBirthdayDelegate {
    func didEditBirthday(birthday:UserBirthday)
}



class AddBirthdayController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    
//    var delegate: BirthdayDelegate?
    var entry: String?
    var mode = Mode.add
    var previousController:String?
    var delegate:AddBirthdayDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onColor  = UIColor.UIColorFromRGB(0x33b5d3)
        let offColor = UIColor.UIColorFromRGB(0x709E85)
        
        
        /*For on state*/
        visibilitySwitch.onTintColor = onColor
        
        /*For off state*/
        visibilitySwitch.tintColor = offColor
        visibilitySwitch.layer.cornerRadius = 16
        visibilitySwitch.backgroundColor = offColor
        
        
        visibilitySwitch.on = false
        visibilitySwitch.tintColor = UIColor.whiteColor()
        visibilitySwitch.transform = CGAffineTransformMakeScale(0.80, 0.80);
        //visibilitySwitch.backgroundColor = UIColor.whiteColor()
        
        datePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -100, toDate: NSDate(), options: [])
        datePicker.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -13, toDate: NSDate(), options: [])

        
        disableNext()
        
        datePicker.addTarget(self, action: #selector(AddBirthdayController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        visibilitySwitch.addTarget(self, action: #selector(AddBirthdayController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if previousController == "Profile" {
            let profileController = self.delegate as? ProfileViewController
            if (profileController?.birthdayLabel.text?.characters.count)! > 0 || !(profileController?.birthdayLabel.text?.isEmpty)! {
                let dateString = profileController?.birthdayLabel.text
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM dd yyyy"
                let dateObj = dateFormatter.dateFromString(dateString!)
                datePicker.date = dateObj!
                
                enableNext()

            }
        }else {
            if let unwrappedEntry = entry {
                let dateString = unwrappedEntry
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM dd yyyy"
                let dateObj = dateFormatter.dateFromString(dateString)
                
                datePicker.date = dateObj!
            }     
        }
        
        

    }
    
    func switchChanged(mySwitch: UISwitch) {
        let on = mySwitch.on
        visibilityLabel.text = on == true ? "visible" : "hidden"
    }
    
    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        //self.delegate?.pickerDidChange(dateFormatter.stringFromDate(sender.date))
        SignupManager.sharedInstance.userBirthday = UserBirthday(date: dateFormatter.stringFromDate(sender.date))
        
        enableNext()
        
    }
    
    

    @IBAction func backAction(sender: AnyObject) {
        if mode == .edit {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            
            self.delegate?.didEditBirthday(UserBirthday(date: dateFormatter.stringFromDate(datePicker.date), visible: visibilitySwitch.on))
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            self.performSegueWithIdentifier("backToAddName", sender: self)

        }
    }

    @IBAction func nextAction(sender: AnyObject) {
        
        if mode == .edit {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            
            dateFormatter.stringFromDate(datePicker.date)
            self.delegate?.didEditBirthday(UserBirthday(date: dateFormatter.stringFromDate(datePicker.date), visible: visibilitySwitch.on))

            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            
            SignupManager.sharedInstance.userBirthday?.visible = visibilitySwitch.on
            
            self.performSegueWithIdentifier("gotoAddLocation", sender: self)
        }

    }
    
    @IBAction func backToAddBirthday(segue: UIStoryboardSegue) {}

}


extension AddBirthdayController {
    func disableNext() {
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.setTitleColor(UIColor(white: 1.0, alpha: 1.0), forState: UIControlState.Normal)

        nextButton.tintColor = UIColor.UIColorFromRGB(0xffffff)
       // nextButton.setTitleColor(UIColor(rgb: 0xffffff, alphaVal: 0.4), forState: .Normal)
        nextButton.enabled = false
    }
    
    func enableNext() {
        nextButton.layer.borderWidth = 0
        nextButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.tintColor = UIColor.UIColorFromRGB(0x7BC8A4)
        nextButton.enabled = true
        
    }
    
}
