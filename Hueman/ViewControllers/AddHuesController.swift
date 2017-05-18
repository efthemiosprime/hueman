//
//  AddHuesController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddHuesController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var profileHues: [ProfileHue]?
    var hues: [String: String] = [:]
    
    @IBOutlet weak var progressIndicator: UIView!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    let SKIP_LABEL = "start exploring hueman"
    
    let defautls = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]

        for (index, hue) in profileHues!.enumerate() {
            hue.type = topics[index]
            let hueGesture = UITapGestureRecognizer(target: self, action: #selector(AddHuesController.addHue(_:)))
            hue.tag = index
            hue.addGestureRecognizer(hueGesture)
        }

        
        hues = [
            Topic.Wanderlust: "",
            Topic.OnMyPlate: "",
            Topic.RelationshipMusing: "",
            Topic.Health: "",
            Topic.DailyHustle: "",
            Topic.RayOfLight: ""
        ]
        
        buttonSkip()
        backButton.tintColor = UIColor.UIColorFromRGB(0x666666)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let signupManager = SignupManager.sharedInstance

        print("view will appear \(signupManager.currentUser?.hues)")
        progressIndicator.hidden = true
        if let signupHues = signupManager.currentUser?.hues{
            for profileHue in profileHues! {
                if let hueType = profileHue.type {
                    print("signupHues \(signupHues)")
                    if let desc = signupHues[hueType] {
                        setHue(desc, type: hueType)

                    }

                }

            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier  == "AddHue" {
            if sender != nil {
                
                if let unwrappedHue = sender as? ProfileHue {
                    let addHueController = segue.destinationViewController as! AddHueController
                    addHueController.delegate = self
                    addHueController.type = unwrappedHue.type
                }
                
            }
        }
        
    }
    func addHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        self.performSegueWithIdentifier("AddHue", sender: hue )

        
    }

    @IBAction func backAddHues(segue: UIStoryboardSegue) {}

    @IBAction func backAction(sender: AnyObject) {
        self.performSegueWithIdentifier("backToBio", sender: self)
    }
    
    @IBAction func exploreAction(sender: AnyObject) {
        

        showIndicator()
        SignupManager.sharedInstance.editProfile({
            SignupManager.sharedInstance.dispose()
            self.performSegueWithIdentifier("gotoExplore", sender: self)
            self.hideIndicator()
        })
        
    }

}

extension AddHuesController: AddHueDelegate {
    func setHue(hue: String, type: String) {
        switch type {
        case Topic.Wanderlust:
            let data = ProfileHueModel(title: "I’d love to travel to", description: hue, type: Topic.Wanderlust)
            profileHues![0].data = data
            self.hues[Topic.Wanderlust] = data.description
            break
            
        case Topic.OnMyPlate:
            let data = ProfileHueModel(title: "I can’t stop eating", description: hue, type: Topic.OnMyPlate)
            profileHues![1].data = data
            self.hues[Topic.OnMyPlate] = data.description
            
            break
            
        case Topic.RelationshipMusing:
            let data = ProfileHueModel(title: "I cherish my", description: hue, type: Topic.RelationshipMusing)
            profileHues![2].data = data
            self.hues[Topic.RelationshipMusing] = data.description
            
            
            break
            
        case Topic.Health:
            let data = ProfileHueModel(title: "I keep healthy by", description: hue, type: Topic.Health)
            profileHues![3].data = data
            self.hues[Topic.Health] = data.description
            
            break
            
        case Topic.DailyHustle:
            let data = ProfileHueModel(title: "I am an amazing", description: hue, type: Topic.DailyHustle)
            
            profileHues![4].data = data
            self.hues[Topic.DailyHustle] = data.description
            
            break
            
            
            
        default:
            let data = ProfileHueModel(title: "Hapiness is", description: hue, type: Topic.RayOfLight)
            
            profileHues![5].data = data
            self.hues[Topic.RayOfLight] = data.description
            break
        }
        
        
        SignupManager.sharedInstance.currentUser?.hues = hues
        buttonNext()
        
    }
}


extension AddHuesController {
    func buttonNext() {
        nextButton.layer.borderWidth = 0
        nextButton.backgroundColor = UIColor.UIColorFromRGB(0x666666)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextButton.setTitle(SKIP_LABEL, forState: .Normal)
    }
    
    func buttonSkip() {
        nextButton.layer.borderWidth = 1
        nextButton.setTitleColor(UIColor(rgb: 0x666666, alphaVal: 0.4), forState: .Normal)
        nextButton.layer.borderColor = UIColor(rgb: 0x666666, alphaVal: 0.4).CGColor
        nextButton.tintColor = UIColor.UIColorFromRGB(0x666666)
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.setTitle(SKIP_LABEL, forState: .Normal)

    }
    
    
    func showIndicator() {
        progressIndicator.hidden = false
        activityIndicator.show()
        
    }
    
    func hideIndicator() {
        progressIndicator.hidden = true
        activityIndicator.hide()
        
    }
    
}
