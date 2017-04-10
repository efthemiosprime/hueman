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

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var addButton: RoundedCornersButton!
    var delegate: AddHueDelegate?

    var type: String?
    var hueIndex: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var currentTypeColor: UInt = Color.Wanderlust
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableNext()
        detailLabel.delegate = self

        if let unwrappedType = type {
            switch unwrappedType {
                
                
            case Topic.Wanderlust:
                icon.image = UIImage(named: "hue-wanderlust-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Wanderlust)
                currentTypeColor = Color.Wanderlust
                iconLabel.text = "wanderlust"
                titleLabel.text  = "I would love to visit"
                footerLabel.text = "Name a place that you’d like to visit."
                break
                
            case Topic.OnMyPlate:
                icon.image = UIImage(named: "hue-plate-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                currentTypeColor = Color.OnMyPlate

                iconLabel.text = "on my plate"
                titleLabel.text  = "I love to stuff myself with"
                footerLabel.text = "What’s your favorite food?"
                break
                
            case Topic.RelationshipMusing:
                icon.image = UIImage(named: "hue-love-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                currentTypeColor = Color.RelationshipMusing

                iconLabel.text = "love musings"
                titleLabel.text  = "I cherish my relationship with"
                footerLabel.text = "What is one relationship that you cherish dearly?"
                
                break
                
            case Topic.Health:
                icon.image = UIImage(named: "hue-health-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                currentTypeColor = Color.Health

                iconLabel.text = "oh health yeah"
                titleLabel.text  = "I keep health / fit by"
                footerLabel.text = "What do you like to eat / do to keep healthy or fit?"
                
                break
                
            case Topic.DailyHustle:
                icon.image = UIImage(named: "hue-hustle-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                currentTypeColor = Color.DailyHustle

                iconLabel.text = "daily hustle"
                titleLabel.text  = "I am a"
                footerLabel.text = "What do you do for a living?\nWhere are you studying?"
                
                break
                
                
                
            default:
                icon.image = UIImage(named: "hue-ray-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                currentTypeColor = Color.RayOfLight

                iconLabel.text = "ray of light"
                titleLabel.text  = "What makes you smile?"
                footerLabel.text = "can turn my day around"
                
                break
            }
        }
        
        
        detailLabel.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        addDoneBtnToKeyboard()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
//        
//        if let text = defaults.objectForKey(type!) as? String   {
//            detailLabel.text = text
//        }
        
    }
    
    


    
    func textFieldDidChange(textField: UITextField){
        
        
        
        if textField.text?.characters.count > 3 {
            enableNext()
            defaults.setObject(textField.text, forKey: type!)
        }
        
  //      let charCount: String = String(textField.text!.characters.count)
//        if textField.text?.characters.count > 1 {
//            charactersLabel.text = "\(charCount)/30 characters"
//        }
//        
    }


    @IBAction func addAction(sender: AnyObject) {
        
        
        if let text = detailLabel.text where !text.isEmpty {
            self.delegate?.setHue(detailLabel.text!, type: self.type!)
            self.performSegueWithIdentifier("backAddHues", sender: nil)

        } else {
            self.performSegueWithIdentifier("backAddHues", sender: nil)

        }
        

    }

    
    func addDoneBtnToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace , target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.doneEditing))
        doneBtn.tintColor = UIColor.UIColorFromRGB(0x666666)
        
        if let font = UIFont(name: Font.SofiaProRegular, size: 15) {
            doneBtn.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        toolbar.setItems([spacer, doneBtn], animated: false)
        
        detailLabel.inputAccessoryView = toolbar
        
    }
    

    
    func doneEditing() {
        
        self.view.endEditing(true)
        detailLabel.resignFirstResponder()
        
    }
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


extension AddHueController {
    func disableNext() {
        addButton.setTitle("maybe later", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        addButton.backgroundColor = UIColor.clearColor()
        
    }
    
    func enableNext() {
        addButton.setTitle("next", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.UIColorFromRGB(currentTypeColor), forState: UIControlState.Normal)

        addButton.layer.borderWidth = 0
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        addButton.backgroundColor = UIColor.whiteColor()
        addButton.tintColor = UIColor.UIColorFromRGB(0xf49445)
        
    }
    
}
