//
//  BirthdayController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol BirthdayDelegate {
    func pickerDidChange(date: String)
}

class BirthdayController: UIViewController {

    @IBOutlet weak var birthdayPicker: UIDatePicker!
    var delegate: BirthdayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        birthdayPicker.subviews[0].subviews[1].backgroundColor = UIColor.redColor()
        birthdayPicker.subviews[0].subviews[2].backgroundColor = UIColor.redColor()
        birthdayPicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        birthdayPicker.setValue(false, forKey: "highlightsToday")
        
        birthdayPicker.addTarget(self, action: #selector(BirthdayController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        self.delegate?.pickerDidChange(dateFormatter.stringFromDate(sender.date))
        
    }

}
