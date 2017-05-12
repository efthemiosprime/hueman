//
//  SegueFromRight.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/3/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class SegueFromRight: UIStoryboardSegue {

    override func perform() {
        
        // Assign the source and destination views to local variables.
        let firstVCView = self.sourceViewController.view as UIView!
        let secondVCView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
//        let statusBarView = UIView(frame: CGRectMake(screenWidth, 0, screenWidth, UIApplication.sharedApplication().statusBarFrame.size.height) )
//        statusBarView.backgroundColor = secondVCView.backgroundColor
        
        UIGraphicsBeginImageContextWithOptions(secondVCView.bounds.size, false, 0.0)

        secondVCView.drawViewHierarchyInRect(secondVCView.frame, afterScreenUpdates: true)
        let screenshot = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()

        
      //  firstVCView.addSubview(statusBarView)
        firstVCView.addSubview(screenshot)
        
        screenshot.frame = CGRectMake(screenWidth, 0
, screenWidth, screenHeight )
        // Specify the initial position of the destination view.
      //  secondVCView.frame = CGRectMake(screenWidth, 0.0, screenWidth, screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
       // let window = UIApplication.sharedApplication().keyWindow
      //  window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        
        
        
        
        // Animate the transition.
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, -screenWidth, 0.0)
          //  secondVCView.frame = CGRectOffset(secondVCView.frame, -screenWidth, 0.0)
            
        }) { (Finished) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                                                            animated: false,
                                                            completion: {
                                                                
//                                                                statusBarView.removeFromSuperview()
                                                                screenshot.removeFromSuperview()

            })
        }
    }
}
