//
//  CreatePostViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/22/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var inputBackground: UIView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
        self.navigationController?.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x93648D)

        inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
        inputBackground.layer.borderWidth = 2
        inputBackground.layer.borderColor = UIColor.whiteColor().CGColor

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
