//
//  EditProfileViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/7/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var birthdayImage: UIImageView!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 130
        profileImage.contentMode = .ScaleAspectFill
        
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.addGestureRecognizer(profileImageTapGesture)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        
        let birthdayImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(birthdayImageTapped))
        birthdayImage.addGestureRecognizer(birthdayImageTapGesture)
        
        birthdayDatePicker.addTarget(self, action: #selector(EditProfileViewController.handleBirthdayPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)

        birthdayDatePicker.backgroundColor = UIColor.whiteColor()
        birthdayDatePicker.hidden = true
        
        

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func profileImageTapped() {
        handleSelectedProfileImageView()
    }
    
    func birthdayImageTapped() {

        birthdayDatePicker.hidden = false
    

    }
    
    func handleBirthdayPicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        dateLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
    // Dismissing all editing actions when User Tap or Swipe down on the Main View
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
        if birthdayDatePicker.hidden == false {
            birthdayDatePicker.hidden = true
        }

    }
    

    
}


