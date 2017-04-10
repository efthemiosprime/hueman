//
//  UnwindSegueFromRight.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/3/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

class UnwindSegueFromRight: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        let toViewController = self.destinationViewController
        let fromViewController = self.sourceViewController
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
    
        
        UIGraphicsBeginImageContextWithOptions(toViewController.view.bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        toViewController.view.layer.renderInContext(context!)
        let screenshot = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()
        
        
        fromViewController.view.addSubview(screenshot)
        screenshot.frame = CGRectMake(-screenWidth, 0, screenWidth, screenHeight)
//        let finalToFrame = screenBounds
//        let finalFromFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
//        
//        toViewController.view.frame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
//        containerView?.addSubview(toViewController.view)
        
        // Animate the transition.
        UIView.animateWithDuration(0.5, animations: {
            fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, screenWidth, 0.0)

            }, completion: { finished in
                let window = UIApplication.sharedApplication().keyWindow
                window?.subviews.last?.removeFromSuperview()
                screenshot.removeFromSuperview()

                let fromVC: UIViewController = self.sourceViewController
                fromVC.dismissViewControllerAnimated(false, completion: nil)
        })

    }
}
//let toViewController = destinationViewController
//let fromViewController = sourceViewController
//
//let containerView = fromViewController.view.superview
//let screenBounds = UIScreen.mainScreen().bounds
//
//let finalToFrame = screenBounds
//let finalFromFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
//
//toViewController.view.frame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
//containerView?.addSubview(toViewController.view)
//
//UIView.animateWithDuration(0.5, animations: {
//    toViewController.view.frame = finalToFrame
//    fromViewController.view.frame = finalFromFrame
//    }, completion: { finished in
//        let fromVC: UIViewController = self.sourceViewController
//        fromVC.dismissViewControllerAnimated(false, completion: nil)
//})
