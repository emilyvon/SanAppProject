//
//  DataService.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/18/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://sanappetite.firebaseio.com"

class DataService {
    
    static let ds = DataService()  //static, only one instance in memory and make it globally accessible
    
    //Implement thing that can  interact with Firebase in DataService
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")

    
    var REF_BASE: Firebase {
        
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: Firebase {
        
        //Access the current specific user uid
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        //Grab the specific user  REF BASE / users / uid
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    //THIS IS HOW YOU CREATE A USER AND ADDS IT TO FIREBASE AUTOMATICALLY
    //Create a user with a uid and keys and values
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        
        //REF USER / uid then save it under the user category for the specific user, sets the value username: username or provider: email of facebook for example
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    ///////////
    func observeCurrentUser() {
        REF_USER_CURRENT.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let user = snapshot.value as! [String: AnyObject]
            NSUserDefaults.standardUserDefaults().setObject(user, forKey: KEY_CURRENT_USER)
        }
    }
    //////////////
}

