//
//  LoginViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/4/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //printFonts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName)
            print("Font Names = [\(names)]")
        }
    }

}
