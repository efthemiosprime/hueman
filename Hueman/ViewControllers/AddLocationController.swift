//
//  AddLocationController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/30/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate {
    func setLocation(location: String)
}


class AddLocationController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    
    var locationManager:CLLocationManager!
    let geoCoder = CLGeocoder()

    var delegate: LocationDelegate?
    
    var entry: String?

    var mode = Mode.add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.delegate = self

        locationField.contentHorizontalAlignment = .Center
        locationField.attributedPlaceholder = NSAttributedString(string: "Type here...", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        locationField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        disableNext()
        addDoneBtnToKeyboard()
        

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationField.becomeFirstResponder()
        
        print("view did load")

        if let unwrappedEntry = entry {
            
            locationField.text = unwrappedEntry
            
        }else {
            if CLLocationManager.locationServicesEnabled() {
                if CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                    determineMyCurrentLocation()

                }

            }else {
                print("Location services are not enabled")
            }
            
        }
        
        
    }
    


//    @IBAction func didTappedConfirmButton(sender: AnyObject) {
//        
//           self.delegate?.setLocation(locationField.text!)
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
    
    @IBAction func backAction(sender: AnyObject) {
        
        if mode == .edit {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else {
            self.performSegueWithIdentifier("backToAddBirthday", sender: self)
            
        }
        
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        print("next action")
        if SignupManager.sharedInstance.userLocation == nil {
            SignupManager.sharedInstance.userLocation = UserLocation(location: self.locationField.text!, visible: self.visibilitySwitch.on)
        }else {
            SignupManager.sharedInstance.userLocation!.location = locationField.text
        }
        
        SignupManager.sharedInstance.createProfile({
            SignupManager.sharedInstance.dispose()
            self.performSegueWithIdentifier("gotoInterstitial", sender: self)
        })
        
    }
    func textFieldDidChange(textField: UITextField){
        
        
        
        if textField.text?.characters.count > 3 {

            enableNext()

        }

//        let charCount: String = String(textField.text!.characters.count)
//        if textField.text?.characters.count > 1 {
//            charactersLabel.text = "\(charCount)/30 characters"
//        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
        
        locationField.inputAccessoryView = toolbar
        
    }
    
    
    
    func doneEditing() {
        
        self.view.endEditing(true)
        locationField.resignFirstResponder()
        
    }

}


extension AddLocationController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       // textField.resignFirstResponder()
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


extension AddLocationController: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        


        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            
            // City
            if let state = placeMark.addressDictionary!["State"] as? NSString, let city = placeMark.addressDictionary!["City"] as? NSString {
                self.locationField.text = "\(city), \(state)"
                if SignupManager.sharedInstance.userLocation == nil {
                    SignupManager.sharedInstance.userLocation = UserLocation(location: self.locationField.text!, visible: self.visibilitySwitch.on)
                    self.locationField.becomeFirstResponder()
                    manager.stopUpdatingLocation()
                }else {
                    SignupManager.sharedInstance.userLocation!.location = self.locationField.text
                }
                
                self.enableNext()
                manager.stopUpdatingLocation()
            }

            
        })
        
    
        manager.stopUpdatingLocation()
    }
    

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error \(error)")

    }

}


extension AddLocationController {
    func disableNext() {
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        nextButton.backgroundColor = UIColor.clearColor()
        //nextButton.tintColor = UIColor.UIColorFromRGB(0xf49445)
        nextButton.enabled = false
    }
    
    func enableNext() {
        nextButton.layer.borderWidth = 0
        nextButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.tintColor = UIColor.UIColorFromRGB(0x7bc8a4)
        nextButton.enabled = true
        
    }
    
}

