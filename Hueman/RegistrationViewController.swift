//
//  RegistrationViewController
//  Hueman
//
//  Created by Hueman on 9/28/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Foundation

class RegistrationViewController: UIViewController {

    let newUserNameInput: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if juliusIsTryingToRegister() {
            reject()
        }else {
            accept()
        }

    }
    
    func juliusIsTryingToRegister() -> Bool{
        
        let possibleJuliusInputString = "julius|hulyo|kamote|busa|kristina|kalbo|nycrunner"
        return newUserNameInput!.rangeOfString(possibleJuliusInputString, options: .RegularExpressionSearch) != nil
        
    }
    
    func reject() {}
    func accept () {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
