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
    @IBOutlet weak var filterView: UIView!
    @IBOutlet var hues: Array<UIButton>?
    var delegate : FilterControllerDelegate?
    var topics = [String]()
    var filters = [String]()
    
    let defaults = NSUserDefaults.standardUserDefaults()

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
        
        if let savedFilters = defaults.objectForKey("savedFilters") as? [String] {
            for filter in savedFilters {
                if let tag = topics.indexOf(filter) {
                    hues![tag].selected = true
                }
            }
        }

        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FilterController.back))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let frame = self.filterView.frame

            self.filterView.frame = frame.offsetBy(dx: 0, dy: frame.size.height)
            
            
        }) { (Finished) -> Void in
            
        }

        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    

    
    @IBAction func didTappedClose(sender: AnyObject) {
        back()

    }
    
    
    func back() {
        self.filter()
        self.selfDestruct()
    }
    
    func filter() {
        
        for btn in hues! {
            if btn.selected {
                filters.append(topics[btn.tag])
            }
        }
        
        if filters.count > 0 {
            defaults.setObject(filters, forKey: "savedFilters")
        }else {
            defaults.removeObjectForKey("savedFilters")
        }
        
        self.delegate?.onFilter(filters)
        
        

    }
    
    func selfDestruct() {
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let frame = self.filterView.frame
            
            self.filterView.frame = frame.offsetBy(dx: 0, dy: -frame.size.height)
            
            
        }) { (Finished) -> Void in
            
            self.didMoveToParentViewController(nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
        }
        



    }

    func filterFeeds(sender: UIButton) {
        
        sender.selected = !sender.selected
       // print(sender.selected)
       // self.delegate?.onFilter(topics[sender.tag])
      //  self.selfDestruct()
    }

}
