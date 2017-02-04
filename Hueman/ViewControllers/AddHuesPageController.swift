//
//  AddHuesPageController.swift
//  Hueman
//
//  Created by Efthemios Prime on 1/31/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import UIKit

protocol AddHuesPageDelegate {
    func setHue(hue: String, type: String)
}


class AddHuesPageController: UIPageViewController {
    
    var topics: NSArray = NSArray()
    var selectedHueIndex = 0
    var hueDelegate: AddHueDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        topics = [Topic.Wanderlust, Topic.OnMyPlate, Topic.RelationshipMusing, Topic.Health, Topic.DailyHustle, Topic.RayOfLight]
        
        
        self.setViewControllers([getViewControllerAtIndex(selectedHueIndex)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
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
    
    
    func getViewControllerAtIndex(index: NSInteger) -> AddHueController
    {
        // Create a new view controller and pass suitable data.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addHueController = storyboard.instantiateViewControllerWithIdentifier("AddHue") as! AddHueController
        
        
        addHueController.type = "\(topics[index])"
        addHueController.hueIndex = index
        addHueController.delegate = hueDelegate
        
        print("xxxx controller")

        return addHueController
    }

}


extension AddHuesPageController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageContent: AddHueController = viewController as! AddHueController
        print(pageContent.detailLabel.text)

        var index = pageContent.hueIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        

        return getViewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageContent: AddHueController = viewController as! AddHueController
        
        var index = pageContent.hueIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == topics.count)
        {
            return nil;
        }
        
        return getViewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return topics.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return selectedHueIndex
    }
    

}


extension AddHuesPageController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool)
    {
        //        guard completed else { return }
        //        print("xxxxx")
        
        if(completed) {
            let prev = pageViewController as? AddHueController
            print(prev!.detailLabel.text)
        }
    }
    

}
