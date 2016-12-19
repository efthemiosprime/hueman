//
//  RegistrationManager.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/18/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

class RegistrationManager {
    
    var user: User?
    
    struct Static
    {
        private static var instance: RegistrationManager?
    }
    
    
    class var sharedInstance: RegistrationManager
    {
        if Static.instance == nil
        {
            Static.instance = RegistrationManager()
        }
        
        return Static.instance!
    }
    
    
    func dispose() {
        RegistrationManager.Static.instance = nil
    }
}
