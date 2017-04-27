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
    func getFriendsList(tokenString: String) {
        let params = ["fields": "id, first_name, last_name, name"]
      //  let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
        let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params, tokenString: tokenString, version: "v2.4", HTTPMethod: "GET")
       // let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: params, HTTPMethod: "GET")
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil {
                let errorMessage = error.localizedDescription
                /* Handle error */
                print("error \(errorMessage)")
            }
            else if result.isKindOfClass(NSDictionary){
                /*  handle response */
                print("results \(result)")
                let resultdict = result as! NSDictionary

                let data : NSArray = resultdict.objectForKey("data") as! NSArray

                for i in 0..<data.count {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    print("the id value is \(id)")
                }
            }
        }
        
    }
}
