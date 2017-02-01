//
//  AddHueController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/31/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol AddHueDelegate {
    func setHue(hue: String, type: String)
}


class AddHueController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var charactersLabel: UILabel!
    var delegate: AddHueDelegate?

    var type: String?
    var hueIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailLabel.delegate = self
        //confirmButton.enabled = false
        detailLabel.becomeFirstResponder()
        
        
        if let unwrappedType = type {
            switch unwrappedType {
                
                
            case Topic.Wanderlust:
                icon.image = UIImage(named: "hue-wanderlust-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                iconLabel.text = "wanderlust"
                titleLabel.text  = "I would love to visit"
                footerLabel.text = "Name a place that you’d like to visit."
                break
                
            case Topic.OnMyPlate:
                icon.image = UIImage(named: "hue-plate-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.OnMyPlate)

                iconLabel.text = "on my plate"
                titleLabel.text  = "I love to stuff myself with"
                footerLabel.text = "What’s your favorite food?"
                break
                
            case Topic.RelationshipMusing:
                icon.image = UIImage(named: "hue-love-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)

                iconLabel.text = "love musings"
                titleLabel.text  = "I cherish my relationship with"
                footerLabel.text = "What is one relationship that you cherish dearly?"
                
                break
                
            case Topic.Health:
                icon.image = UIImage(named: "hue-health-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.Health)

                iconLabel.text = "oh health yeah"
                titleLabel.text  = "I keep health / fit by"
                footerLabel.text = "What do you like to eat / do to keep healthy or fit?"
                
                break
                
            case Topic.DailyHustle:
                icon.image = UIImage(named: "hue-hustle-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.DailyHustle)

                iconLabel.text = "daily hustle"
                titleLabel.text  = "I am a"
                footerLabel.text = "What do you do for a living?\nWhere are you studying?"
                
                break
                
                
                
            default:
                icon.image = UIImage(named: "hue-ray-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                self.navigationBar.barTintColor = UIColor.UIColorFromRGB(Color.RayOfLight)

                iconLabel.text = "ray of light"
                titleLabel.text  = "What makes you smile?"
                footerLabel.text = "can turn my day around"
                
                break
            }
        }
        
        
        detailLabel.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationBar.topItem!.title = "create profile"
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SofiaProRegular", size: 20)!,NSForegroundColorAttributeName : UIColor.UIColorFromRGB(0xffffff)]
    }
    
    func textFieldDidChange(textField: UITextField){
        
        
        
        if textField.text?.characters.count > 3 {
            confirmButton.enabled = true
        }
        let charCount: String = String(textField.text!.characters.count)
        if textField.text?.characters.count > 1 {
            charactersLabel.text = "\(charCount)/30 characters"
        }
        
    }


    @IBAction func didTappedConfirm(sender: AnyObject) {
        self.delegate?.setHue(detailLabel.text!, type: self.type!)
        self.dismissViewControllerAnimated(true, completion: nil)

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



extension AddHueController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Moving the View up after the Keyboard appears
    func textFieldDidBeginEditing(textField: UITextField) {
        //animateView(true, moveValue: 80)
        detailLabel.placeholder = nil

        
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
