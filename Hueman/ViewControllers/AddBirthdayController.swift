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
    
    
    var delegate: BirthdayDelegate?
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
        
        
        datePicker.addTarget(self, action: #selector(BirthdayController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    
    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        self.delegate?.pickerDidChange(dateFormatter.stringFromDate(sender.date))
        
    }
    
    

    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("backToAddPhoto", sender: self)
    }

    @IBAction func backToAddBirthday(segue: UIStoryboardSegue) {}

}
