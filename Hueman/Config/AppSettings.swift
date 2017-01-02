//
//  AppSettings.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/22/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import Foundation

class AppSettings {
    
    static let sharedInstance = AppSettings()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    static var DEBUG: Bool = false
}
