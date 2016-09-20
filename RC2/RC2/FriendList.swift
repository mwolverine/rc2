//
//  FriendList.swift
//  RC2
//
//  Created by Chris Yoo on 9/20/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import Foundation

class Friend {
    
    let friendUID: String
    let friendDisplayName: String
    let friendMiles: Double
    
    init(friendUID: String, friendDisplayName: String, friendMiles: Double){
        self.friendUID = friendUID
        self.friendDisplayName = friendDisplayName
        self.friendMiles = friendMiles
    }
}