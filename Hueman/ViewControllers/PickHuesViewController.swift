//
//  PickHuesViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class PickHuesViewController: UIViewController {
    
    @IBOutlet var hues: Array<UIButton>?
    
    @IBOutlet weak var backButton: UIButton!
    
    var hueColors: [UInt] = [UInt]()
    var hueIcons: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for btn in hues! {
            btn.addTarget(self, action: #selector(PickHuesViewController.createPostWithTopic(_:)), forControlEvents: .TouchUpInside)
        }
        
        backButton.addTarget(self, action: #selector(PickHuesViewController.backButtonAction), forControlEvents: .TouchUpInside)
        
        hueColors.append(Color.Wanderlust)
        hueColors.append(Color.OnMyPlate)
        hueColors.append(Color.RelationshipMusing)
        hueColors.append(Color.Health)
        hueColors.append(Color.DailyHustle)
        hueColors.append(Color.RayOfLight)

        hueIcons.append(Icon.Wanderlust)
        hueIcons.append(Icon.OnMyPlate)
        hueIcons.append(Icon.RelationshipMusing)
        hueIcons.append(Icon.Health)
        hueIcons.append(Icon.DailyHustle)
        hueIcons.append(Icon.RayOfLight)
    }

    func createPostWithTopic(btn: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createPostController: CreatePostViewController = storyboard.instantiateViewControllerWithIdentifier("CreatePost") as! CreatePostViewController
        
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
