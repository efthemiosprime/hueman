//
//  PickHuesViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class PickHuesViewController: UIViewController {

    @IBOutlet weak var wanderlustButton: UIButton!
    @IBOutlet weak var plateButton: UIButton!
    @IBOutlet weak var relationshipButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var dailyhustleButton: UIButton!
    @IBOutlet weak var raylightButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var hueColors: [UInt] = [UInt]()
    var hueIcons: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let huesButton: [UIButton] = [wanderlustButton, plateButton, relationshipButton, healthButton, dailyhustleButton, raylightButton]
        
     //   let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PickHuesViewController.showDescription))
        for btn in huesButton {
            btn.addTarget(self, action: #selector(PickHuesViewController.createPostWithTopic(_:)), forControlEvents: .TouchUpInside)
           // btn.addGestureRecognizer(longPressRecognizer)
            
        }
        

        backButton.addTarget(self, action: #selector(PickHuesViewController.backButtonAction), forControlEvents: .TouchUpInside)
        hueColors.append(Hues.WanderlustColor)
        hueColors.append(Hues.OnMyPlateColor)
        hueColors.append(Hues.RelationshipMusingColor)
        hueColors.append(Hues.HealthColor)
        hueColors.append(Hues.DailyHustleColor)
        hueColors.append(Hues.RayOfLightColor)

        hueIcons.append(Hues.WanderlustIcon)
        hueIcons.append(Hues.OnMyPlateIcon)
        hueIcons.append(Hues.RelationshipMusingIcon)
        hueIcons.append(Hues.HealthIcon)
        hueIcons.append(Hues.DailyHustleIcon)
        hueIcons.append(Hues.RayOfLightIcon)
    }

    func createPostWithTopic(btn: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createPostController: CreatePostViewController = storyboard.instantiateViewControllerWithIdentifier("CreatePost") as! CreatePostViewController
        print(btn.tag)
        createPostController.topicColor = hueColors[btn.tag]
        createPostController.topicIcon = hueIcons[btn.tag]
        presentViewController(createPostController, animated: true, completion: nil)
    }
    
    func showDescription() {
        print("long press to show description")
    }
    
    func backButtonAction() {
        self.dismissViewControllerAnimated(true, completion: {})
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
