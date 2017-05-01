//
//  OnboardingPageController.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/23/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//


import UIKit


class OnboardingPageController: UIPageViewController {
    
    var onboardings = [Onboarding]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        onboardings = [
            Onboarding(title: "", imageName: "onboarding-welcome", background: "onboarding-welcome-bg", description: "Celebrate life's awesome moments in a safe and positive space - free from online bullying and abuse!"),
            Onboarding(title:"Share", imageName: "onboarding-share", background: "onboarding-share-bg", description: "Share stories with hues that represent positive, inspiring and fun topics that bring people together."),
            Onboarding(title:"Flag", imageName: "onboarding-flag", background: "onboarding-flag-bg", description: "Click the flag button and help remove hateful posts or comments in our community."),
            Onboarding(title:"Customize", imageName: "onboarding-customize", background: "onboarding-customize-bg", description: "Customize your feed right from your home screen, and browse topics you’re in the mood to see!")

        ]

        
        
        self.setViewControllers([getViewControllerAtIndex(selectedIndex)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.mainScreen().bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func getViewControllerAtIndex(index: NSInteger) -> OnboardingController
    {
        // Create a new view controller and pass suitable data.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingController = storyboard.instantiateViewControllerWithIdentifier("OnboardingItem") as! OnboardingController
        
        
        onboardingController.index = index
        onboardingController.data = onboardings[index]
        onboardingController.delegate = self
      //  onboardingController.delegate = hueDelegate
        
        
        return onboardingController
    }
    
}


extension OnboardingPageController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageContent: OnboardingController = viewController as! OnboardingController
        
        selectedIndex = pageContent.index
        
        if ((selectedIndex == 0) || (selectedIndex == NSNotFound))
        {
            return nil
        }
        
        selectedIndex -= 1;
        
        
        return getViewControllerAtIndex(selectedIndex)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageContent: OnboardingController = viewController as! OnboardingController
        
        var selectedIndex = pageContent.index
        
        if (selectedIndex == NSNotFound)
        {
            return nil;
        }
        
        selectedIndex += 1;
        if (selectedIndex == onboardings.count)
        {
            return nil;
        }
        
        return getViewControllerAtIndex(selectedIndex)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return onboardings.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {

        return selectedIndex
    }
    
    
}


extension OnboardingPageController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool)
    {
        //        guard completed else { return }
        
        if(completed) {
        }
    }
}


extension OnboardingPageController: OnboardingDelegate {

    
    func gotoNextPage(index: Int) {
        selectedIndex = index + 1

        guard let currentPage = self.viewControllers?.first else {return}
        guard let nextPage = dataSource?.pageViewController( self, viewControllerAfterViewController: currentPage ) else { return }
                setViewControllers([nextPage], direction: .Forward, animated: true, completion: nil)
        
    }
    
    func getTotalPage() -> Int {
        return onboardings.count
    }
}

