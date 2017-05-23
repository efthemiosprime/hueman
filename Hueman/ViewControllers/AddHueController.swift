//
//  AddHueController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/31/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

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
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    
    
    var delegate: AddHueDelegate?

    var type: String?
    var hueIndex: Int = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var currentTypeColor: UInt = Color.Wanderlust
    var mode: Mode?
    
    
    var previousController: UIViewController?
    var prev: String?
    var placeHolderText = ""
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
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
               // iconLabel.text = "wanderlust"
                titleLabel.text  = HueTitle.Wanderlust
                footerLabel.text = "Name a place you’d like to visit."
                detailLabel.placeholder = "e.g., Paris, France"
                headerLabel.text = "wanderlust"
                placeHolderText = "e.g., Paris, France"
                break
                
            case Topic.OnMyPlate:
                icon.image = UIImage(named: "hue-plate-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.OnMyPlate)
                currentTypeColor = Color.OnMyPlate

              //  iconLabel.text = "on my plate"
                titleLabel.text  = HueTitle.OnMyPlate
                footerLabel.text = "What’s your favorite food?"
                detailLabel.placeholder = "e.g., Chicken and waffles"
                placeHolderText = "e.g., Chicken and waffles"
                headerLabel.text = "on my plate"
                break
                
            case Topic.RelationshipMusing:
                icon.image = UIImage(named: "hue-love-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RelationshipMusing)
                currentTypeColor = Color.RelationshipMusing

            //    iconLabel.text = "heart musings"
                titleLabel.text  = HueTitle.RelationshipMusing
                footerLabel.text = "What’s one relationship you value dearly?"
                detailLabel.placeholder = "e.g., Family"
                placeHolderText = "e.g., Family"

                headerLabel.text = "heart musings"
                break
                
            case Topic.Health:
                icon.image = UIImage(named: "hue-health-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.Health)
                currentTypeColor = Color.Health

             //   iconLabel.text = "oh health yeah"
                titleLabel.text  = HueTitle.Health
                footerLabel.text = "What diet or physical activity do you do?"
                detailLabel.placeholder = "e.g., Walking everyday"
                headerLabel.text = Topic.Health.lowercaseString
                placeHolderText = "e.g., Walking everyday"

                
                break
                
            case Topic.DailyHustle:
                icon.image = UIImage(named: "hue-hustle-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.DailyHustle)
                currentTypeColor = Color.DailyHustle

           //     iconLabel.text = HueTitle.DailyHustle
                titleLabel.text  = "I am an amazing"
                footerLabel.text = "What do you do for a living?\nWhere are you studying?"
                detailLabel.placeholder = "e.g., College student"
                placeHolderText = "e.g., College student"

                headerLabel.text = Topic.DailyHustle.lowercaseString

                break
                
                
                
            default:
                icon.image = UIImage(named: "hue-ray-icon")
                self.view.backgroundColor = UIColor.UIColorFromRGB(Color.RayOfLight)
                currentTypeColor = Color.RayOfLight

         //      iconLabel.text = "ray of light"
                titleLabel.text  = HueTitle.RayOfLight
                footerLabel.text = "Name a random thing that makes you smile."
                headerLabel.text = Topic.RayOfLight.lowercaseString
                detailLabel .placeholder = "e.g., Puppy photos"
                placeHolderText = "e.g., Puppy photos"

                break
            }
        }
        
        
        detailLabel.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        addDoneBtnToKeyboard()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
//        

        if let unwrappedType = type {
            if let text = defaults.objectForKey(unwrappedType) as? String   {
                detailLabel.text = text
                enableNext()
            }
        }

    }
    
    
    func textFieldDidChange(textField: UITextField){
        
        
        if textField.text?.characters.count > 1 {
            enableNext()
            if let unwrappedType = type {
                defaults.setObject(textField.text, forKey: unwrappedType)
            }
        }
        
        if textField.text?.characters.count == 0 || textField.text!.isEmpty {
            disableNext()
            if let unwrappedType = type {
                defaults.removeObjectForKey(unwrappedType)
            }
        }
        
   
    }


    @IBAction func addAction(sender: AnyObject) {
        
        if mode == .edit {
            
            let autManager = AuthenticationManager.sharedInstance
            if let unwrappedUid = autManager.currentUser?.uid {
                if let unwrappedType = type {
                    dataBaseRef.child("users").child(unwrappedUid).child("hues").updateChildValues([unwrappedType: detailLabel.text!], withCompletionBlock: { (error, ref) in
                        
                    })
                    
                }else {
                    let profileController = self.delegate as? ProfileViewController
                    profileController?.editMode = true
                    self.delegate?.setHue(detailLabel.text!, type: self.type!)
                }
            }
            

            AuthenticationManager.sharedInstance.loadCurrentUser({
                self.dismissViewControllerAnimated(true, completion: nil)

            })

            
        }
        
        if mode == nil || mode == .add {
//            if let text = detailLabel.text where !text.isEmpty {
//                self.delegate?.setHue(detailLabel.text!, type: self.type!)
//                self.performSegueWithIdentifier("backAddHues", sender: nil)
//            }
//            
            if detailLabel.text?.characters.count > 1 || !detailLabel.text!.isEmpty {
                self.delegate?.setHue(detailLabel.text!, type: self.type!)
                self.performSegueWithIdentifier("backAddHues", sender: nil)
            }else {
                self.performSegueWithIdentifier("backAddHues", sender: nil)
            }
        }


    }

    @IBAction func backAction(sender: AnyObject) {
        
        
        if detailLabel.text!.isEmpty || detailLabel.text?.characters.count == 0 {
            if let unwrappedType = self.type {
                //  self.delegate?.setHue("", type: unwrappedType)
                defaults.removeObjectForKey(unwrappedType)
                detailLabel.text = ""
                detailLabel.placeholder = placeHolderText
            }
        }
        
        if mode == .edit {

            

            
            
            let autManager = AuthenticationManager.sharedInstance
            if let unwrappedUid = autManager.currentUser?.uid {
                if let unwrappedType = type {
                    dataBaseRef.child("users").child(unwrappedUid).child("hues").updateChildValues([unwrappedType: detailLabel.text!], withCompletionBlock: { (error, ref) in
                            
                        AuthenticationManager.sharedInstance.loadCurrentUser({
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        })
                    })

                }
            }
            



        }else {

            
            self.performSegueWithIdentifier("backAddHues", sender: nil)
        }

    }
    
    @IBAction func removeAction(sender: AnyObject) {
        if let unwrappedType = self.type {
            self.delegate?.setHue("", type: unwrappedType)
            defaults.removeObjectForKey(unwrappedType)
            defaults.synchronize()

        }

        detailLabel.text = ""
        detailLabel.placeholder = placeHolderText
        disableNext()
        self.dismissViewControllerAnimated(true, completion: nil)


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
        addButton.setTitle("add", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), forState: UIControlState.Normal)
        addButton.layer.borderWidth = 1
       // addButton.layer.borderColor = UIColor.whiteColor().CGColor
        addButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor

        addButton.backgroundColor = UIColor.clearColor()
        addButton.enabled = false
    }
    
    func enableNext() {
        addButton.setTitle("add", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.UIColorFromRGB(currentTypeColor), forState: UIControlState.Normal)

        addButton.layer.borderWidth = 0
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        addButton.backgroundColor = UIColor.whiteColor()
        addButton.tintColor = UIColor.UIColorFromRGB(0xf49445)
        addButton.enabled = true

    }
    
}
