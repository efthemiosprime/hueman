//
//  WelcomeController.swift
//  Hueman
//
//  Created by Efthemios Prime on 3/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class WelcomeController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: ActivityIndicator!
    
    @IBOutlet weak var cover: UIView!
    let firebaseManager = FirebaseManager()

    var hasLogin = false
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var timer: NSTimer = NSTimer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorContainer.hidden = true
//        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
//        print(appDelegate.window?.top?.isKindOfClass(WelcomeController))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
        if hasLogin {
            if let fbAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("accessToken") as? String {
                showIndicator()

                firebaseManager.loginWithFacebookAcessToken(fbAccessToken, loggedIn: {
                    self.hideIndicator()
                    print("facebook login")

                    self.performSegueWithIdentifier("LoginConfirmed", sender: nil)

                })

            }else {
                if let storedEmail = NSUserDefaults.standardUserDefaults().valueForKey("email") as? String, let storedPassword = firebaseManager.keychainWrapper.myObjectForKey("v_Data") as? String {
                    
                    showIndicator()
                    
                    firebaseManager.logIn(storedEmail, password: storedPassword, loggedIn: {
                        // AuthenticationManager.sharedInstance
                        self.hideIndicator()
                        
                        
                        self.performSegueWithIdentifier("LoginConfirmed", sender: nil)
                        
                        }, onerror: { errorMsg in
                            
                            self.hideIndicator()
                            self.showError(errorMsg)
                            
                    })
                }
            }
        }else {
            UIView.animateWithDuration(0.5, animations: {
                self.cover.alpha = 0
                }, completion: {
                    (value: Bool) in
                    self.cover.hidden = true
            })
        }
          
    }
    
    @IBAction func facebookLoginAction(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        
        loginManager.logInWithReadPermissions(["email", "public_profile", "user_about_me", "user_friends"], fromViewController: self, handler: {
            (result, error) in
            
            self.showIndicator()
            
            
            guard error == nil else {
                print(error)
                self.showError(error.localizedDescription)
                return
            }
            
            if result.isCancelled {
                self.hideIndicator()
                self.showError("cancelled")
                return
            }
            

            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"], tokenString: result.token.tokenString, version: "v2.4", HTTPMethod: "GET")
            req.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if(error == nil)
                {
                    if (result.valueForKey("email") as? String) != nil {
                        if let picture = result["picture"] {
                            if let data = picture!["data"]{
                                if let url = data!["url"] as? String {
                                    
                                    self.firebaseManager.loginWithFacebook(url, loggedIn: {
                                        
                                        self.performSegueWithIdentifier("gotoFacebookInterstitial", sender: sender)
                                        
                                        self.hideIndicator()
                                        
                                    })
                                    
                                }
                            }
                        }
                    }else {
                        self.showError("authorize facebook to use email")
                        self.hideIndicator()

                       /// self.firebaseManager.facebookLogout()
                    }
                }else
                {
                    self.showError(error.localizedDescription)
                    
                }
            }
            
        })
    }


}


extension WelcomeController {
    
    func showIndicator() {
        startTimer()
        activityIndicatorContainer.hidden = false
        activityIndicator.show()

    }
    
    func hideIndicator() {
        stopTimer()
        activityIndicatorContainer.hidden = true
        activityIndicator.hide()

    }
    
    func showError(msg: String) {
        let errorController: ErrorController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("errorID") as? ErrorController)!
        // errorController.preferredContentSize = CGSizeMake(300, 150)
        errorController.modalPresentationStyle = UIModalPresentationStyle.Popover
        errorController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        errorController.popoverPresentationController?.delegate = self
        errorController.popoverPresentationController?.sourceView = self.view
        errorController.popoverPresentationController?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
        
        // set up the popover presentation controller
        errorController.errorMsg = msg
        
        self.presentViewController(errorController, animated: true, completion: nil)
    }
    
    
    // MARK: - Popover
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        UIView.animateWithDuration(0.5, animations: {
            self.cover.alpha = 0
            }, completion: {
                (value: Bool) in
                self.cover.hidden = true
        })
    }
    
    
    // MARK: - Timer
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(40, target: self, selector: #selector(WelcomeController.checkProgress), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        if  timer.valid {
            timer.invalidate()
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.cover.alpha = 0
            }, completion: {
                (value: Bool) in
                self.cover.hidden = true
        })
    }
    
    func checkProgress() {
        stopTimer()
        
        if activityIndicatorContainer.hidden == false {

            hideIndicator()
        }
    }
}
