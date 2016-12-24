//
//  FilterController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/22/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol FilterControllerDelegate {
    func onFilter(topics: [String])
}



class FilterController: UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet var hues: Array<UIButton>?
    var delegate : FilterControllerDelegate?
    var topics = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

        topics.append(Topic.Wanderlust)
        topics.append(Topic.OnMyPlate)
        topics.append(Topic.RelationshipMusing)
        topics.append(Topic.Health)
        topics.append(Topic.DailyHustle)
        topics.append(Topic.RayOfLight)

        for hue in hues! {
            hue.addTarget(self, action: #selector(FilterController.filterFeeds(_:)), forControlEvents: .TouchUpInside)
        }
        
//        // Creating Tap Gesture to dismiss Keyboard
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FilterController.selfDestruct))
//        tapGesture.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didTappedClose(sender: AnyObject) {
        
        var filters = [String]()
        for btn in hues! {
            if btn.selected {
                filters.append(topics[btn.tag])
            }
        }
        
        self.delegate?.onFilter(filters)
    

        selfDestruct()
        
    }
    
    func selfDestruct() {
        self.didMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    func filterFeeds(sender: UIButton) {
        
        sender.selected = !sender.selected
       // print(sender.selected)
       // self.delegate?.onFilter(topics[sender.tag])
      //  self.selfDestruct()
    }

}
