//
//  OnboardingController.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/23/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController {

    @IBOutlet weak var welcomeHeaderImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nextButton: RoundedCornersButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    
    var index:Int = 0
    
    var data: Onboarding?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = UIImage(named: "onboarding-customize-bg.png")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        onboardingImage.image = UIImage(named: (data?.imageName)!)
        descriptionLabel.text = data?.description
        
    }

    func set() {
        
    }

}
