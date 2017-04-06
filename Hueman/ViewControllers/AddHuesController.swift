//
//  AddHuesController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class AddHuesController: UIViewController {

    @IBOutlet var profileHues: [ProfileHue]?
    var hues: [String: String] = [:]

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
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier  == "AddHue" {
            if sender != nil {
                
                if let unwrappedType = sender {
                    let addHueController = segue.destinationViewController as! AddHueController
                    addHueController.delegate = self
                    addHueController.type = unwrappedType as? String
                    
                }
                
            }
        }
        
    }
    func addHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        self.performSegueWithIdentifier("AddHue", sender: hue?.type )

        
    }

    @IBAction func backAddHues(segue: UIStoryboardSegue) {}


}

extension AddHuesController: AddHueDelegate {
    func setHue(hue: String, type: String) {
        switch type {
        case Topic.Wanderlust:
            let data = ProfileHueModel(title: "I would love to visit", description: hue, type: Topic.Wanderlust)
            profileHues![0].data = data
            self.hues[Topic.Wanderlust] = data.description
            break
            
        case Topic.OnMyPlate:
            let data = ProfileHueModel(title: "I love to stuff myself with", description: hue, type: Topic.OnMyPlate)
            profileHues![1].data = data
            self.hues[Topic.OnMyPlate] = data.description
            
            break
            
        case Topic.RelationshipMusing:
            let data = ProfileHueModel(title: "I cherish my relationship with", description: hue, type: Topic.Wanderlust)
            profileHues![2].data = data
            self.hues[Topic.RelationshipMusing] = data.description
            
            
            break
            
        case Topic.Health:
            let data = ProfileHueModel(title: "I keep health / fit by", description: hue, type: Topic.Health)
            profileHues![3].data = data
            self.hues[Topic.Health] = data.description
            
            break
            
        case Topic.DailyHustle:
            let data = ProfileHueModel(title: "I am a", description: hue, type: Topic.DailyHustle)
            
            profileHues![4].data = data
            self.hues[Topic.DailyHustle] = data.description
            
            break
            
            
            
        default:
            let data = ProfileHueModel(title: "What makes you smile?", description: hue, type: Topic.RayOfLight)
            
            profileHues![5].data = data
            self.hues[Topic.RayOfLight] = data.description
            break
        }    }
}
