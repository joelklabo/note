//
//  CurrentUserState.swift
//  Note
//
//  Created by Joel Klabo on 8/20/14.
//  Copyright (c) 2014 Joel Klabo. All rights reserved.
//

import Foundation

class CurrentUserState {
    
    class private func userIDKey () -> String {
        return "com.note.currentUserIDKey"
    }
    
    class func updateUserID (userID: String) -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userID, forKey: CurrentUserState.userIDKey())
        defaults.synchronize()
    }
    
    func userID () -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(CurrentUserState.userIDKey()) as? String
    }
    
    func userAvailable () -> Bool {
        if let userID = userID() {
            return true
        } else {
            return false
        }
    }
    
}