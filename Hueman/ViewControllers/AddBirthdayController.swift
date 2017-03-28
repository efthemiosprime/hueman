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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visibilitySwitch.on = false
        visibilitySwitch.tintColor = UIColor.whiteColor()
        visibilitySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        //visibilitySwitch.backgroundColor = UIColor.whiteColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }

}
