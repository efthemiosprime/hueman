//
//  FilterOptionsViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class FilterOptionsViewController: UIViewController {
    

    @IBOutlet var checkboxes: Array<UIButton>?
    @IBOutlet var ratings: Array<UIButton>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for checkbox in checkboxes! {
            checkbox.addTarget(self, action: #selector(FilterOptionsViewController.onSelectFilterOptions(_:)), forControlEvents: .TouchUpInside)
        }
        
        for rating in ratings! {
            rating.addTarget(self, action: #selector(FilterOptionsViewController.onSelectRating(_:)), forControlEvents: .TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
                self.dismissViewControllerAnimated(true, completion: {})
    }

    func onSelectFilterOptions(checkbox: UIButton) {
        
        for current in checkboxes! {
            if current.tag != checkbox.tag {
                current.selected = false
            }
        }
        
        checkbox.selected = !checkbox.selected
        
    }
    
    func onSelectRating(sender: UIButton) {
        for rating in ratings! {
            if rating.tag != sender.tag {
                rating.selected = false
            }
        }
        
        sender.selected = !sender.selected
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
