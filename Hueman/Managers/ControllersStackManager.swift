//
//  ControllersStackManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/2/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation

class ControllersStackManager {
    
    var controllers = [UIViewController]()
    
    
    struct Static
    {
        private static var instance: ControllersStackManager?
    }
    
    
    class var sharedInstance: ControllersStackManager
    {
        if Static.instance == nil
        {
            Static.instance = ControllersStackManager()
        }
        
        return Static.instance!
    }
    
    
    private init() {
    }
    
    
    
    
    func dispose() {
        if controllers.count > 0 {
            controllers.removeAll()
        }
        ControllersStackManager.Static.instance = nil
    }
}

// let imagePt = UIImage(data: (caminhodaImagem as! NSData) as Data)
