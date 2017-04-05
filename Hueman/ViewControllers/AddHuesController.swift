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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topics: [String] = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]

        for (index, hue) in profileHues!.enumerate() {
            hue.type = topics[index]
            let hueGesture = UITapGestureRecognizer(target: self, action: #selector(AddHuesController.addHue(_:)))
            hue.tag = index
            hue.addGestureRecognizer(hueGesture)
        }

    }

    
    
    func addHue(sender: UITapGestureRecognizer) {
        let hue = (sender as UITapGestureRecognizer).view as? ProfileHue
        print("tage \(hue!.tag) ")
        self.performSegueWithIdentifier("AddHue", sender: hue?.tag )

        
    }

    @IBAction func backAddHues(segue: UIStoryboardSegue) {}


}
