//
//  ProfileViewController+Edit.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/30/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation

extension ProfileViewController {
    
    func addEditGestures() {
        for hue in hues! {
//            hue.multipleTouchEnabled = true
            let editGesture = UITapGestureRecognizer(target: self, action: #selector(editHue(_:)))
            hue.addGestureRecognizer(editGesture)
        }
        
        let profileImageGesture = UITapGestureRecognizer(target: self, action: #selector(editProfileImage(_:)))
        profileImage.addGestureRecognizer(profileImageGesture)
        
        let editBirthdayGesture = UITapGestureRecognizer(target: self, action: #selector(ediBirthday(_:)))
        birthday.addGestureRecognizer(editBirthdayGesture)
        
        let editLocationGesture = UITapGestureRecognizer(target: self, action: #selector(editLocation(_:)))
        location.addGestureRecognizer(editLocationGesture)
        
        
        let bioEditIconGesture = UITapGestureRecognizer(target: self, action: #selector(editBio(_:)))
        bioEditIcon.addGestureRecognizer(bioEditIconGesture)
    }
    
    func enableGestures() {
        for hue in hues! {
            hue.userInteractionEnabled = true
        }
        
        birthday.userInteractionEnabled = true
        location.userInteractionEnabled = true
        bioEditIcon.userInteractionEnabled = true
        profileImage.userInteractionEnabled = true

    }
    func disableGestures() {
        for hue in hues! {
            hue.userInteractionEnabled = false
        }
        
        bioEditIcon.userInteractionEnabled = false

        birthday.userInteractionEnabled = false
        location.userInteractionEnabled = false
        profileImage.userInteractionEnabled = false
    }
    
    func done() {
        editMode = false
        self.navigationBar.topItem?.rightBarButtonItem = editButton
        viewPostButtonHeightConstraint.constant = 39

        profileImage.alpha = 1
        for hue in hues! {
            hue.mode = nil
        }

        bioEditIcon.hidden = true
        locationEditIcon.hidden = true
        birthdayEditIcon.hidden = true
        
        
        if ((birthdayLabel.text?.isEmpty) != nil) {
            birthdayPlusIcon.hidden = true
        }else {
            birthdayPlusIcon.hidden = false
        }
        
        if ((locationLabel.text?.isEmpty) != nil) {
            locationPlusIcon.hidden = true
        }else {
            locationPlusIcon.hidden = false
        }
        photoEditLabel.hidden = true

        
        disableGestures()
    }
    func edit() {
        editMode = true
        profileImage.alpha = 0.5
        self.navigationBar.topItem?.rightBarButtonItem = doneButton
        photoEditLabel.hidden = false
        viewPostButtonHeightConstraint.constant = 0
        enableGestures()
        
        for hue in hues! {
            hue.mode = Mode.edit
            hue.multipleTouchEnabled = true
        }
        
        bioEditIcon.hidden = false
        if ((birthdayLabel.text?.isEmpty) != nil) {
            birthdayEditIcon.hidden = false
            birthdayPlusIcon.hidden = true
        }else {
            birthdayEditIcon.hidden = true
            birthdayPlusIcon.hidden = false
        }
        
        if ((locationLabel.text?.isEmpty) != nil) {
            locationEditIcon.hidden = false
            locationPlusIcon.hidden = true
        }else {
            locationEditIcon.hidden = true
            locationPlusIcon.hidden = false
        }
        
        
        enableGestures()

    }
    
    func editHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        self.performSegueWithIdentifier("EditHue", sender: hue)
    }
    
    func ediBirthday(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("EditBirthday", sender: nil)
    }
    
    func editLocation(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("EditLocation", sender: nil)
    }
    
    func editBio(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("EditBio", sender: nil)

    }
    func editProfileImage(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("EditProfileImage", sender: nil)

    }
    
}

// MARK: - AddHueDelegate
extension ProfileViewController: AddHueDelegate {
    func setHue(hue: String, type: String) {

            switch type {
            case Topic.Wanderlust:
                let data = ProfileHueModel(title: "I would love to visit", description: hue, type: Topic.Wanderlust)
                if hue.characters.count > 0 || !hue.characters.isEmpty {
                    hues![0].data = data
                    self.editedHues![Topic.Wanderlust] = data.description
                }else {
                    self.editedHues![Topic.Wanderlust] = autManager?.currentUser?.hues[Topic.Wanderlust]

                }

                break
                
            case Topic.OnMyPlate:
                let data = ProfileHueModel(title: "I love to stuff myself with", description: hue, type: Topic.OnMyPlate)
                if hue.characters.count > 0 {
                    hues![1].data = data
                    self.editedHues![Topic.OnMyPlate] = data.description

                }else {
                    self.editedHues![Topic.OnMyPlate] = autManager?.currentUser?.hues[Topic.OnMyPlate]

                }

                break
                
            case Topic.RelationshipMusing:
                let data = ProfileHueModel(title: "I cherish my relationship with", description: hue, type: Topic.RelationshipMusing)
                if hue.characters.count > 0 {
                    hues![2].data = data
                    self.editedHues![Topic.RelationshipMusing] = data.description

                }else {
                    self.editedHues![Topic.RelationshipMusing] = autManager?.currentUser?.hues[Topic.RelationshipMusing]

                }
              //  signupManager.currentUser?.hues = editedHues!

                break
                
            case Topic.Health:
                let data = ProfileHueModel(title: "I keep health / fit by", description: hue, type: Topic.Health)
                if hue.characters.count > 0 {
                    hues![3].data = data
                    self.editedHues![Topic.Health] = data.description
                }else {
                    self.editedHues![Topic.Health] = autManager?.currentUser?.hues[Topic.Health]

                }
              //  signupManager.currentUser?.hues = editedHues!

                break
                
            case Topic.DailyHustle:
                let data = ProfileHueModel(title: "I am a", description: hue, type: Topic.DailyHustle)
                if hue.characters.count > 0 {
                    hues![4].data = data
                    self.editedHues![Topic.DailyHustle] = data.description
                }else {
                    self.editedHues![Topic.DailyHustle] = autManager?.currentUser?.hues[Topic.DailyHustle]

                }
              //  signupManager.currentUser?.hues = editedHues!

                break
                
                
                
            default:
                let data = ProfileHueModel(title: "Happiness is", description: hue, type: Topic.RayOfLight)
                if hue.characters.count > 0 {
                    hues![5].data = data
                    self.editedHues![Topic.RayOfLight] = data.description
                }else {
                    self.editedHues![Topic.RayOfLight] = autManager?.currentUser?.hues[Topic.RayOfLight]

                }
               // signupManager.currentUser?.hues = editedHues!

                break
            }
        
        

        
    }
}

// MARK: - AddProfilePhotoDelegate
extension ProfileViewController: AddProfilePhotoDelegate {
    func editPhoto(imageData: NSData?) {
        self.editedImageData = imageData
    }
}


// MARK: - AddLocationDelegate
extension ProfileViewController: AddLocationDelegate {
    func didEditLocation(location: UserLocation) {
        self.editedLocation = location
    }
}
// MARK: - AddBirthdayDelegate
extension ProfileViewController: AddBirthdayDelegate {
    func didEditBirthday(birthday: UserBirthday) {
        editedBirthday = birthday
    }
}

// MARK: - AddBioDelegate
extension ProfileViewController: AddBioDelegate {
    func didEditBio(bio: String) {
        editedBio = bio
    }
}
