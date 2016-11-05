//
//  SearchBarViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/21/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController {

    @IBOutlet weak var writePostButton: UIButton!
    @IBOutlet weak var filterPostsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writePostButton.addTarget(self, action: #selector(TabBar.createPost), forControlEvents: .TouchUpInside)
        
        filterPostsButton.addTarget(self, action: #selector(TabBar.filterOption), forControlEvents: .TouchUpInside)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
