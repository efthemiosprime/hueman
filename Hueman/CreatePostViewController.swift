//
//  CreatePostViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/22/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos
import MobileCoreServices

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var inputBackground: UIView!
    @IBOutlet weak var postInput: UITextView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var topic: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var wanderlustButton: UIButton!
    @IBOutlet weak var plateButton: UIButton!
    @IBOutlet weak var relationshopButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var hustleButton: UIButton!
    @IBOutlet weak var raylightButton: UIButton!
    
    var topicColor: UInt?
    var topicIcon: String?

    
    @IBAction func backButton(sender: AnyObject) {
        postInput?.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: {})

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTopic(true)
        
        postInput.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x93648D)

        inputBackground.layer.borderWidth = 2
        inputBackground.layer.borderColor = UIColor.whiteColor().CGColor
        
        if let topicColor = topicColor, let topicIcon = topicIcon {
            
            updateTopic(topicColor, hueIcon: topicIcon)
            
        }
        

        let buttons: [UIButton] = [wanderlustButton, plateButton, relationshopButton, healthButton, hustleButton, raylightButton]
        
        for btn in buttons {
            btn.addTarget(self, action: #selector(CreatePostViewController.topicChangedAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        cameraButton.addTarget(self, action: #selector(CreatePostViewController.openPhotoLibrary), forControlEvents: .TouchUpInside)
        filterButton.addTarget(self, action: #selector(CreatePostViewController.showTopicAction), forControlEvents: .TouchUpInside)
        

        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postInput?.becomeFirstResponder()
        
    }
    
    func showTopic(show: Bool) {
        topic.hidden = show

    }
    

    func topicChangedAction(sender: UIButton!) {
        if sender.tag == 0 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            icon.image = UIImage(named: "wanderlust-icon.png")
        }
        
        if sender.tag == 1 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            icon.image = UIImage(named: "plate-icon.png")
        }
        
        if sender.tag == 2 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            icon.image = UIImage(named: "relationship-icon.png")
        }
        
        if sender.tag == 3 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            icon.image = UIImage(named: "health-icon.png")
        }
        
        if sender.tag == 4 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            icon.image = UIImage(named: "hustle-icon.png")
        }
        
        if sender.tag == 5 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            icon.image = UIImage(named: "ray-light-icon.png")
        }
        
        showTopic(true)
    }

    func showTopicAction() {
        showTopic(false)
    }
    
    func updateTopic(hueColor: UInt, hueIcon: String) {
        self.view.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        inputBackground.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        icon.image = UIImage(named: hueIcon)
    }
    
    func openPhotoLibrary() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CreatePostViewController: UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    func textViewDidChange(textView: UITextView) {
        headerLabel.text = "\(250 - textView.text.characters.count)/250 characters left"
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            postInput.resignFirstResponder()
            return false
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= 250
    }
    

}


