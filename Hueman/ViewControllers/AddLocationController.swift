//
//  AddLocationController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol LocationDelegate {
    func setLocation(location: String)
}


class AddLocationController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var charactersLabel: UILabel!
    
    var delegate: LocationDelegate?
    
    var entry: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.enabled = false
        
        locationField.delegate = self

        locationField.contentHorizontalAlignment = .Center
        locationField.attributedPlaceholder = NSAttributedString(string: "Type here...", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        locationField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        
        if let unwrappedEntry = entry {
            
            locationField.text = unwrappedEntry
            confirmButton.enabled = true
            
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        locationField.becomeFirstResponder()
        
        self.navigationBar.topItem!.title = "add location"
        self.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x999999)
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0xffffff)]
    }

    @IBAction func didTappedConfirmButton(sender: AnyObject) {
        
           self.delegate?.setLocation(locationField.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func textFieldDidChange(textField: UITextField){
        
        
        
        if textField.text?.characters.count > 6 {
            confirmButton.enabled = true
        }
        let charCount: String = String(textField.text!.characters.count)
        if textField.text?.characters.count > 1 {
            charactersLabel.text = "\(charCount)/30 characters"
        }
        
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


extension AddLocationController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        //animateView(true, moveValue: 80)
        locationField.placeholder = nil
    }
    
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(textField: UITextField) {
        // animateView(false, moveValue: 80)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 30
    }
    
    
}
