//
//  User.swift
//  RC2
//
//  Created by Chris Yoo on 9/20/16.
//  Copyright © 2016 Chris Yoo. All rights reserved.
//

import Foundation

class User {
    
    let displayName: String
    let email: String
    let photoURL: String
    
    init(displayName: String, email: String, photoURL: String) {
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
    }
}