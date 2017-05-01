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
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var textStats: UILabel!
    var submitBtn: UIBarButtonItem!
    var filterBtn: UIBarButtonItem!
    var withImage: Bool = false
    
    
    var keyboardHeight: CGFloat = 0
    var toolbarFilters: UIToolbar?
    
    
    @IBOutlet var huesCollections: Array<UIButton>?
    
    var storedEntry = [String: AnyObject]()
    var mode: String = "create"
    var topicColor: UInt?
    var topicIcon: String?
    var topicString: String? {
        didSet {
            submitBtn.enabled = true
        }
    }
    
    
    var currentUser: User!
    
    var feedManager = FeedManager()
    
    var topicRectOffsets = [CGPoint]()
    
    let defaults = NSUserDefaults.standardUserDefaults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImage.hidden = true
        deleteButton.hidden = true

        
        topicRectOffsets.append(CGPoint(x: -101, y: 23))
        topicRectOffsets.append(CGPoint(x: -74, y: 70))
        topicRectOffsets.append(CGPoint(x: -26, y: 94))
        topicRectOffsets.append(CGPoint(x: 26, y: 94))
        topicRectOffsets.append(CGPoint(x: 74, y: 70))
        topicRectOffsets.append(CGPoint(x: 101, y: 23))


        
        postInput.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.UIColorFromRGB(0x93648D)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        if let topicColor = topicColor, let topicIcon = topicIcon, let topicString = topicString {
            
            updateTopic(topicColor, hueIcon: topicIcon, topic: topicString)
            
        }
    
        
        addButtonToKeyboard()
        addFiltersToolbar()
        
        if let entry = defaults.objectForKey("storedEntry") as? [String: AnyObject] {
            storedEntry = entry
            
            if storedEntry.count > 0 {
                
                if let input = storedEntry["postInput"] as? String {
                    postInput.text = input
                    textStats.text = "\(postInput.text.characters.count)/300"

                }else {
                    postInput.text = "Write here..."
                }
                
                if let topic = storedEntry["topic"] as? String, let icon = storedEntry["icon"] as? String, let color = storedEntry["color"] as? UInt {
                    topicString = topic
                    topicIcon = icon
                    topicColor = color
                    
                    updateTopic(topicColor!, hueIcon: topicIcon!, topic: topicString!)
                    
                }
                
                if mode == "edit" {
                    let imageURL:String = storedEntry["imageURL"] as! String
                    if !imageURL.isEmpty {
                        feedManager.getFeedImage(storedEntry["imageURL"] as! String, complete: {
                            image in
                            self.postImage.image = image
                            self.withImage = true
                            self.postImage.hidden = false
                            self.deleteButton.hidden = false
                        })
                    }

                }else {
                    if let postImageData = storedEntry["postImage"] as? NSData {
                        postImage.image = UIImage(data: postImageData)
                        self.withImage = true
                        postImage.hidden = false
                        deleteButton.hidden = false

                    }
                }

            }

        }
        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postInput?.becomeFirstResponder()
        if mode == "edit" {
            titleLabel.text = "edit post"
        }
        
    }
    

    

    func topicChangedAction(sender: UIButton!) {
        if sender.tag == 0 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x34b5d4)
            filterBtn!.image = UIImage(named: "filter-wanderlust-accessory-icon")
            topicString = Topic.Wanderlust
            topicIcon = "filter-wanderlust-accessory-icon"
            topicColor = 0x34b5d4
        }
        
        
        if sender.tag == 1 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xF49445)
            filterBtn!.image = UIImage(named: "filter-plate-accessory-icon")

            topicString = Topic.OnMyPlate
            topicIcon = "filter-plate-accessory-icon"
            topicColor = 0xF49445
        }
        
        if sender.tag == 2 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xe2563b)
            filterBtn!.image = UIImage(named: "filter-musing-accessory-icon")

            topicString = Topic.RelationshipMusing
            topicIcon = "filter-musing-accessory-icon"
            topicColor = 0xe2563b
        }
        
        if sender.tag == 3 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x7BC8A4)
            filterBtn!.image = UIImage(named: "filter-health-accessory-icon")
            topicString = Topic.Health
            topicIcon = "ilter-health-accessory-icon"
            topicColor = 0x7BC8A4
        }
        
        if sender.tag == 4 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0x93648D)
            filterBtn!.image = UIImage(named: "filter-daily-hustle-accessory-icon")
            topicString = Topic.DailyHustle
            topicIcon = "filter-daily-hustle-accessory-icon"
            topicColor = 0x93648D
        }
        
        if sender.tag == 5 {
            self.view.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            inputBackground.backgroundColor = UIColor.UIColorFromRGB(0xEACD53)
            filterBtn!.image = UIImage(named: "filter-rayoflight-accessory-icon")
            topicString = Topic.RayOfLight
            topicIcon = "filter-rayoflight-accessory-icon"
            topicColor = 0xEACD53
        }
        
        hideFiltersToolbar()
    }


    func updateTopic(hueColor: UInt, hueIcon: String, topic: String) {
        
        topicColor = hueColor
        topicString = topic
        topicIcon = hueIcon
        
        
        self.view.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        inputBackground.backgroundColor = UIColor.UIColorFromRGB(hueColor)
        self.topicString = topic
        filterBtn!.image = UIImage(named: topicIcon!)

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
        

        self.postImage.hidden = false
        self.deleteButton.hidden = false
        withImage = true
        dismissViewControllerAnimated(true, completion: nil)
        postInput.resignFirstResponder()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }



    @IBAction func didTapCreateFeed(sender: AnyObject) {
        submitBtn.enabled = false
        showWaitOverlay()
        
        if mode == "edit" {
            let imageURL:String = storedEntry["imageURL"] as! String

            var editedFeed = Feed(author: "", id: "", uid: "", text: postInput.text, topic: topicString!, imageURL: imageURL)
            
            if withImage {
                editedFeed.withImage = true
                let imageData = UIImageJPEGRepresentation(postImage.image!, 0.1)

                feedManager.editFeed(editedFeed, key: storedEntry["key"] as! String, imageData: imageData,  feedEdited: {
                    self.removeAllOverlays()
                    self.defaults.removeObjectForKey("storedEntry")
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }else {

                feedManager.editFeed(editedFeed, key: storedEntry["key"] as! String, feedEdited: {
                    
                    self.removeAllOverlays()
                    self.defaults.removeObjectForKey("storedEntry")
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }

            

            return
        }

        
        if postInput.text.isEmpty {
            print("input can't be empty")
        }else {
         

            if let text: String = postInput.text, let topic = topicString {
                
        
                let feed = Feed(author: "", id: NSUUID().UUIDString, uid: "", text: text, topic: topic, imageURL: "")
                

                if withImage == true {
                    let imageData = UIImageJPEGRepresentation(postImage.image!, 0.2)
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("PostFeed", object: nil, userInfo: nil)
        

    }

    @IBAction func didTappedDeleteImage(sender: AnyObject) {
        
        removeImage()
    }
    

    
    @IBAction func backButton(sender: AnyObject) {
        
        postInput?.resignFirstResponder()
        
        if mode == "edit" {
            self.defaults.removeObjectForKey("storedEntry")
            self.dismissViewControllerAnimated(true, completion: nil)

            return
        }
        
        if postInput.text.characters.count > 0 {
            storedEntry["postInput"] = postInput.text
        }
        
        if  withImage  {
            storedEntry["postImage"] = UIImageJPEGRepresentation(postImage.image!, 0.2)
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
        for btn in huesCollections! {
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                btn.alpha = 0
                }, completion: { finished in
                })
        }
    }
    

    func removeImage() {

        deleteButton.hidden = true
        postImage.image = UIImage(named: "image_empty")
        postImage.image?.accessibilityIdentifier = "image_empty"
        postImage.hidden = true
        withImage = false
        
        if storedEntry.count > 0 {
            storedEntry.removeValueForKey("postImage")
            storedEntry.removeValueForKey("imageURL")
            storedEntry["postImage"] = nil
            storedEntry["imageURL"]  = nil
            
        }
        
    }

}

extension CreatePostViewController: UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        if postInput.text == "Write here..."{
         //   textView.text = ""
        }
        
 
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Write here..."{
            textView.text = ""
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        textStats.text = "\(textView.text.characters.count)/300"

        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            postInput.resignFirstResponder()
            return false
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= 300
    }
    

}


extension CreatePostViewController {

    func addButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
     //   searhItem = UIBarButtonItem(image: UIImage(named: "search-item-icon"), style: .Plain, target: self, action: #selector(ConnectionsViewController.showSearchBar))

        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace , target: nil, action: nil)
        filterBtn = UIBarButtonItem(image: UIImage(named: "filter-accessory-icon"), style: .Plain, target: self, action: #selector(CreatePostViewController.handleFilter))
        let cameraBtn = UIBarButtonItem(image: UIImage(named: "camera-accessory-icon"), style: .Plain, target: self, action: #selector(CreatePostViewController.handleCamera))
        let photoBtn = UIBarButtonItem(image: UIImage(named: "photo-accessory-icon"), style: .Plain, target: self, action: #selector(CreatePostViewController.handleSelectedFeedImageView))
        submitBtn = UIBarButtonItem(image: UIImage(named: "submit-accessory-icon"), style: .Plain, target: self, action: #selector(CreatePostViewController.didTapCreateFeed(_:)))
        submitBtn.enabled = false
        textStats = UILabel(frame: CGRectMake(0, 0, 60, 21))
        textStats.text = "0/300"
        textStats.textColor = UIColor.UIColorFromRGB(0x666666)
        textStats.font = UIFont(name: Font.SofiaProRegular, size: 16)
        textStats.center = CGPoint(x: CGRectGetMidX(view.frame), y: view.frame.height)
        textStats.textAlignment = NSTextAlignment.Center
        
        let toolbarTitle = UIBarButtonItem(customView: textStats)
        

        toolbar.setItems([filterBtn, cameraBtn,photoBtn, spacer,toolbarTitle, submitBtn], animated: false)
        
        postInput.inputAccessoryView = toolbar
        
    }
    
    func addFiltersToolbar() {

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let icons:[String] = ["filter-wanderlust-accessory-icon", "filter-plate-accessory-icon", "filter-musing-accessory-icon", "filter-health-accessory-icon", "filter-daily-hustle-accessory-icon",  "filter-rayoflight-accessory-icon" ]
        var items = [UIBarButtonItem]()
        
        
        if toolbarFilters == nil {
            var tagIndex = 0
            for item in icons {
                let btnItem = UIBarButtonItem(image: UIImage(named: item), style: .Plain, target: self, action: #selector(CreatePostViewController.topicChangedAction(_:)))
                btnItem.imageInsets = UIEdgeInsetsMake(0.0, -15, 0, -15)
                btnItem.tag = tagIndex
                items.append(btnItem)
                tagIndex += 1
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace , target: nil, action: nil)

            toolbarFilters = UIToolbar()
            toolbarFilters!.frame = CGRectMake(0, screenHeight, screenWidth, 44)
            toolbarFilters!.sizeToFit()
            
            toolbarFilters!.setItems([items[0], spacer, items[1], spacer, items[2], spacer, items[3], spacer, items[4], spacer, items[5]], animated: false)
        
            self.view.addSubview(toolbarFilters!)
        }

    }
    
    func showFiltersToolbar() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toolbarFilters!.frame = CGRectMake(0.0, (screenHeight - self.keyboardHeight) - 43, screenWidth, 44)
        }) { (Finished) -> Void in
        }
    }
    
    func hideFiltersToolbar() {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.toolbarFilters!.frame = CGRectMake(0.0, screenHeight, screenWidth, 44)
        }) { (Finished) -> Void in
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
    }
    
    func handleFilter() {
        showFiltersToolbar()
    }
    
    func doneEditing() {
        self.view.endEditing(true)
        postInput.resignFirstResponder()
    }
    
}


