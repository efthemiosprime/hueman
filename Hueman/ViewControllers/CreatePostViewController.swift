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
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftOverlays
import FirebaseStorage

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var inputBackground: UIView!
    @IBOutlet weak var postInput: UITextView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var topic: UIView!
    @IBOutlet weak var topicCloseButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    
    var withImage: Bool = false
    
    @IBOutlet var huesCollections: Array<UIButton>?
    
    var storedEntry = [String: AnyObject]()
    
    var topicColor: UInt?
    var topicIcon: String?
    var topicString: String? {
        didSet {
            submitButton.enabled = true
        }
    }
    
    
    var currentUser: User!
    
    var feedManager = FeedManager()
    
    var topicRectOffsets = [CGPoint]()
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for btn in huesCollections! {
            btn.addTarget(self, action: #selector(CreatePostViewController.topicChangedAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        topicRectOffsets.append(CGPoint(x: -101, y: 23))
        topicRectOffsets.append(CGPoint(x: -74, y: 70))
        topicRectOffsets.append(CGPoint(x: -26, y: 94))
        topicRectOffsets.append(CGPoint(x: 26, y: 94))
        topicRectOffsets.append(CGPoint(x: 74, y: 70))
        topicRectOffsets.append(CGPoint(x: 101, y: 23))

        
        showTopic(true)
        filterButton.hidden = false
        filterButton.enabled = true
        submitButton.enabled = false
        icon.hidden = true
        
        postInput.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x93648D)

        inputBackground.layer.borderWidth = 2
        inputBackground.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        if let topicColor = topicColor, let topicIcon = topicIcon, let topicString = topicString {
            
            updateTopic(topicColor, hueIcon: topicIcon, topic: topicString)
            
        }
    
        

        
        cameraButton.addTarget(self, action: #selector(CreatePostViewController.handleCamera), forControlEvents: .TouchUpInside)
        filterButton.addTarget(self, action: #selector(CreatePostViewController.showTopicAction), forControlEvents: .TouchUpInside)
        imagePickerButton.addTarget(self, action: #selector(CreatePostViewController.handleSelectedFeedImageView), forControlEvents: .TouchUpInside)
        
        icon.userInteractionEnabled = false
        let tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(CreatePostViewController.showTopicAction))
        icon.addGestureRecognizer(tapIconGesture)
        
        
        if let entry = defaults.objectForKey("storedEntry") as? [String: AnyObject] {
            storedEntry = entry
            
            if storedEntry.count > 0 {
                
                if let input = storedEntry["postInput"] as? String {
                    postInput.text = input
                }
                
                if let topic = storedEntry["topic"] as? String, let icon = storedEntry["icon"] as? String, let color = storedEntry["color"] as? UInt {
                    topicString = topic
                    topicIcon = icon
                    topicColor = color
                    
                    updateTopic(topicColor!, hueIcon: topicIcon!, topic: topicString!)
                    
                }
                
                if let postImageData = storedEntry["postImage"] as? NSData {
                    postImage.image = UIImage(data: postImageData)
                }
            }

        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
   //     postInput?.becomeFirstResponder()
        

    }
    
    func showTopic(show: Bool) {
        if show == true {
            
            let closeFrame = topicCloseButton.frame
            var index = 0
            var done = false
            for btn in huesCollections! {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    btn.frame = closeFrame
                    btn.alpha = 0
                    index = index + 1

                    }, completion: { finished in
                        if done == false {
                            done = true
                            self.topic.hidden = show

                        }
                })
                
            }
            
            
            self.postInput?.userInteractionEnabled = true
            self.postInput?.becomeFirstResponder()
            self.filterButton.hidden = true
            self.icon.hidden = false
            self.icon.userInteractionEnabled = true

    
        }else {
            topic.hidden = show

            openTopic()

            postInput?.userInteractionEnabled = false
            postInput?.resignFirstResponder()
        }


    }
    

    func topicChangedAction(sender: UIButton!) {
        if sender.tag == 0 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            icon.image = UIImage(named: "wanderlust-icon.png")
            topicString = Topic.Wanderlust
            topicIcon = "wanderlust-icon.png"
            topicColor = 0x34b5d4
        }
        
        
        if sender.tag == 1 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            icon.image = UIImage(named: "plate-icon.png")
            topicString = Topic.OnMyPlate
            topicIcon = "plate-icon.png"
            topicColor = 0xF49445
        }
        
        if sender.tag == 2 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            icon.image = UIImage(named: "relationship-icon.png")
            topicString = Topic.RelationshipMusing
            topicIcon = "relationship-icon.png"
            topicColor = 0xe2563b
        }
        
        if sender.tag == 3 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            icon.image = UIImage(named: "health-icon.png")
            topicString = Topic.Health
            topicIcon = "health-icon.png"
            topicColor = 0x7BC8A4
        }
        
        if sender.tag == 4 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            icon.image = UIImage(named: "hustle-icon.png")
            topicString = Topic.DailyHustle
            topicIcon = "hustle-icon.png"
            topicColor = 0x93648D
        }
        
        if sender.tag == 5 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            icon.image = UIImage(named: "ray-light-icon.png")
            topicString = Topic.RayOfLight
            topicIcon = "ray-light-icon.png"
            topicColor = 0xEACD53
        }
        

        showTopic(true)
    }

    func showTopicAction() {
        showTopic(false)
    }
    
    func updateTopic(hueColor: UInt, hueIcon: String, topic: String) {
        
        topicColor = hueColor
        topicString = topic
        topicIcon = hueIcon
        
        
        self.view.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        inputBackground.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        icon.image = UIImage(named: hueIcon)
        self.topicString = topic
        filterButton.hidden = true
        icon.hidden = false
        icon.userInteractionEnabled = true

    }
    
    func handleCamera() {
        let camera = Camera(delegate: self)
        camera.PresentPhotoCamera(self, canEdit: true)
        
    }
    
    func handleSelectedFeedImageView() {
        let camera = Camera(delegate: self)
        camera.PresentPhotoLibrary(self, canEdit: true)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as? UIImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            postImage.image = selectedImage
        }
        

        withImage = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapCreateFeed(sender: AnyObject) {
        submitButton.enabled = false
        showWaitOverlay()

        
        if postInput.text.isEmpty {
            print("input can't be empty")
        }else {
         

            if let text: String = postInput.text, let topic = topicString {
                
        
                let feed = Feed(author: "", id: NSUUID().UUIDString, uid: "", text: text, topic: topic, imageURL: "")
                

                if withImage == true {
                    let imageData = UIImageJPEGRepresentation(postImage.image!, 0.4)
                    feedManager.createFeed(feed, imageData: imageData,  feedPosted: {
                        self.removeAllOverlays()
                        
                        
                        self.defaults.removeObjectForKey("storedEntry")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                }else {
                    feedManager.createFeed(feed, imageData: nil,  feedPosted: {
                        self.removeAllOverlays()
                        self.defaults.removeObjectForKey("storedEntry")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                }
                
            }
            
        }
        

    }
    
    @IBAction func didTappedCloseTopic(sender: AnyObject) {
        showTopic(true)
        if icon.image == nil {
            filterButton.hidden = false
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        postInput?.resignFirstResponder()
        
        
        if postInput.text.characters.count > 0 {
            storedEntry["postInput"] = postInput.text
        }
        
        if postImage.image != nil {
            storedEntry["postImage"] = UIImageJPEGRepresentation(postImage.image!, 0.5)
        }
        
        if topicString != nil {
            if let topic = topicString where !topic.isEmpty {
                storedEntry["topic"] = topic
                storedEntry["icon"] = topicIcon
                storedEntry["color"] = topicColor
            }
        }
        
            
        defaults.setObject(storedEntry, forKey: "storedEntry")
        defaults.synchronize()
       
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func closeTopic() {
        let closeFrame = topicCloseButton.frame
        for btn in huesCollections! {
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                btn.frame = closeFrame
                btn.alpha = 0
                }, completion: { finished in
                })
        }
    }
    
    func openTopic() {
        var index = 0
        
        for btn in huesCollections! {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                btn.frame = btn.frame.offsetBy(dx: self.topicRectOffsets[index].x, dy: self.topicRectOffsets[index].y)
                btn.alpha = 1

                index = index + 1
                }, completion: { finished in


            })
        }
        

    }

}

extension CreatePostViewController: UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if postInput.text == "Write here..." {
            textView.text = ""
        }
        
 
        return true
    }
    func textViewDidChange(textView: UITextView) {
        headerLabel.text = "\(textView.text.characters.count)/250 characters left"

        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            postInput.resignFirstResponder()
            return false
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= 250
    }
    

}


