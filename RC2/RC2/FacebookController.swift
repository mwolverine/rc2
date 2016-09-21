//
//  FacebookController.swift
//  RC2
//
//  Created by Chris Yoo on 9/21/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookController {
    
    var friendData: [String] = []
    
    static let sharedController = FacebookController()
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                
                let resultdict = result as! NSDictionary
                print("Result Dict: \(resultdict)")
                
                let data : NSArray = resultdict.objectForKey("data") as! NSArray
                
                for i in 0..<data.count {
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    let name = valueDict.objectForKey("name") as! String
                    
                    print("the id value is \(id)")
                    print("\(name)")
                    
                    ViewController.sharedController.createFriend("\(id)", friendName: "\(name)")
                    
                }
                
                let friends = resultdict.objectForKey("data") as! NSArray
                print("Found \(friends.count) friends")
                
                //Call function to add friends to friendlist - Retika
                
                //use the list of Facebook user id’s returned in the JSON and populate them into an array so you can compare those user id’s with the user scores in your database,
                
            }
        })
    }
}
