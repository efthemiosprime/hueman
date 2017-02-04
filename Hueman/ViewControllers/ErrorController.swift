//
//  ErrorController.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/1/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class ErrorController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    var errorMsg: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.UIColorFromRGB(0xFF0000)
        if let msg = errorMsg {
            errorLabel.text = msg
        }
        
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 1
        self.view.layer.shadowOffset = CGSize.zero
        self.view.layer.shadowRadius = 5
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.superview!.layer.cornerRadius = 5;
        

        
        print(errorLabel.frame.size.height)
        self.preferredContentSize = CGSizeMake(300, errorLabel.frame.size.height + 60)

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
