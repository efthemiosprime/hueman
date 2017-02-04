//
//  PopoverViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/27/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

protocol PopoverDelegate: class {
    func editPost(feed: Feed)
    func reportPost(feed: Feed)
}

class PopoverViewController: UIViewController {
    
    weak var delegate: PopoverDelegate?
    
    var feed: Feed?
    
    var type:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.superview!.layer.cornerRadius = 6;
        //self.view.superview?.clipsToBounds = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func editPostAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            if let feed = self.feed {
                self.delegate?.editPost(feed)
            }
        })
    }
    
    @IBAction func reportPostAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            if let feed = self.feed {
                self.delegate?.reportPost(feed)
            }
        })
    }
}
