//
//  CreateProfileViewModel.swift
//  Hueman
//
//  Created by Efthemios Prime on 2/21/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreateProfileViewModel: NSObject {
    
    let cachedProfileImage = NSCache()
    var user: User?
    
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference();
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    func getUserImage (complete: ((profileImage: UIImage) -> ())? = nil) {
        storageRef.referenceForURL((user?.photoURL!)!).dataWithMaxSize(1 * 512 * 512, completion: { (data, error) in
            if error == nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    complete?(profileImage: image!)
                }
            }else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    func getUserHues (profileHues: [ProfileHue]) {

        
        if let unwrappedHues = user?.hues {
            for profileHue in profileHues {
                switch profileHue.type! {
                    
                case Topic.Wanderlust:
                    profileHue.data = ProfileHueModel(title: HueTitle.Wanderlust, description: unwrappedHues[Topic.Wanderlust]!, type: Topic.RelationshipMusing)
                    break
                    
                case Topic.OnMyPlate:
                    profileHue.data = ProfileHueModel(title: HueTitle.OnMyPlate, description: unwrappedHues[Topic.OnMyPlate]!, type: Topic.OnMyPlate)
                    break
                    
                case Topic.RelationshipMusing:
                    profileHue.data = ProfileHueModel(title: HueTitle.RelationshipMusing, description: unwrappedHues[Topic.RelationshipMusing]!, type: Topic.RelationshipMusing)
                    break
                    
                case Topic.Health:
                    profileHue.data = ProfileHueModel(title: HueTitle.Health, description: unwrappedHues[Topic.Health]!, type: Topic.Health)
                    break
                    
                case Topic.DailyHustle:
                    profileHue.data = ProfileHueModel(title: HueTitle.DailyHustle, description: unwrappedHues[Topic.DailyHustle]!, type: Topic.DailyHustle)
                    break
                    
                default:
                    profileHue.data = ProfileHueModel(title: HueTitle.RayOfLight, description: unwrappedHues[Topic.RayOfLight]!, type: Topic.RayOfLight)

                }
            }
        }
    }

}
