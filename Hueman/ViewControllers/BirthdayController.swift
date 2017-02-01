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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    var delegate: BirthdayDelegate?
    var entry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.enabled = false
        
        birthdayPicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        birthdayPicker.setValue(false, forKey: "highlightsToday")
        
        
        
        if let unwrappedEntry = entry {
            let dateString = unwrappedEntry
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM dd yyyy"
            let dateObj = dateFormatter.dateFromString(dateString)
            
            
            birthdayPicker.date = dateObj!
            
            confirmButton.enabled = true

        }
        
        
        birthdayPicker.addTarget(self, action: #selector(BirthdayController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.topItem!.title = "add birthday"
        self.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x999999)
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0xffffff)]
    }

    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        
        confirmButton.enabled = true
        self.delegate?.pickerDidChange(dateFormatter.stringFromDate(sender.date))
        
    }

    @IBAction func didTappedConfirmButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
