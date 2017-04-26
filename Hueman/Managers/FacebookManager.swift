//
//  FacebookManager.swift
//  Hueman
//
//  Created by Efthemios Suyat on 4/26/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKShareKit

struct FacebookManager {
    func getFriendsList() {
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil {
                let errorMessage = error.localizedDescription
                /* Handle error */
                print(errorMessage)
            }
            else if result.isKindOfClass(NSDictionary){
                /*  handle response */
                print(result)
            }
        }
        
    }
}
