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
    }
    func disableGestures() {
        for hue in hues! {
            hue.userInteractionEnabled = false
        }
        
        bioEditIcon.userInteractionEnabled = false

        birthday.userInteractionEnabled = false
        location.userInteractionEnabled = false
    }
    
    func done() {
        editMode = false
        self.navigationBar.topItem?.rightBarButtonItem = editButton
        
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

extension ProfileViewController: AddHueDelegate {
    func setHue(hue: String, type: String) {
        func setHue(hue: String, type: String) {
            switch type {
            case Topic.Wanderlust:
                let data = ProfileHueModel(title: "I would love to visit", description: hue, type: Topic.Wanderlust)
                hues![0].data = data
             //   self.hues[Topic.Wanderlust] = data.description
                break
                
            case Topic.OnMyPlate:
                let data = ProfileHueModel(title: "I love to stuff myself with", description: hue, type: Topic.OnMyPlate)
                hues![1].data = data
            //    self.hues[Topic.OnMyPlate] = data.description
                
                break
                
            case Topic.RelationshipMusing:
                let data = ProfileHueModel(title: "I cherish my relationship with", description: hue, type: Topic.RelationshipMusing)
                hues![2].data = data
          //      self.hues[Topic.RelationshipMusing] = data.description
                
                
                break
                
            case Topic.Health:
                let data = ProfileHueModel(title: "I keep health / fit by", description: hue, type: Topic.Health)
                hues![3].data = data
          //      self.hues[Topic.Health] = data.description
                
                break
                
            case Topic.DailyHustle:
                let data = ProfileHueModel(title: "I am a", description: hue, type: Topic.DailyHustle)
                
                hues![4].data = data
          //      self.hues[Topic.DailyHustle] = data.description
                
                break
                
                
                
            default:
                let data = ProfileHueModel(title: "What makes you smile?", description: hue, type: Topic.RayOfLight)
                
                hues![5].data = data
           //     self.hues[Topic.RayOfLight] = data.description
                break
            }
        }
        
    }
}
