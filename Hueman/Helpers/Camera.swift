//
//  Camera.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/23/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

//  reference to David Kababyan
//

import UIKit
import MobileCoreServices

class Camera {
    
    
    //delegate to self
    var delegate:  protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>?
    
    init(delegate:  protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>?){
        self.delegate = delegate
    }
    
    //handle choose photo
    func PresentPhotoLibrary(target: UIViewController, canEdit: Bool) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        //photo library
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            imagePicker.sourceType = .PhotoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                
                if (availableTypes as NSArray).containsObject(type) {
                    
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            
            imagePicker.sourceType = .SavedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.SavedPhotosAlbum) {
                
                if (availableTypes as NSArray).containsObject(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    //handle photo camera
    func PresentPhotoCamera(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return
        }
        
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if let availableTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera) {
                
                if (availableTypes as NSArray).containsObject(type1) {
                    
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                }
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.Front) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
        } else {
            //show alert no camera
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.presentViewController(imagePicker, animated: true, completion: nil)
    }
}

