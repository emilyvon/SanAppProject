//
//  Post.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/25/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import Foundation
import Firebase

//Store the data in this cass

class Post {
    
    private var _postDescription: String!
    private var _postImageUrl: String?
    private var _likes: Int!
    private var _dislikes: Int!
    private var _firstName: String!
    private var _lastName: String!
    private var _username: String!
    private var _postKey: String! //post uid
    
    //Firebase reference to a specific post
    private var _postRef: Firebase!
    
    var postDescription: String! {
        
        return _postDescription
    }
    
    var postImageUrl: String? {
        
        return _postImageUrl
    }
    
    var likes: Int {
        
        return _likes
    }
    
    var dislikes: Int {
        
        return _dislikes
    }
    
    var firstName: String {
        
        return _firstName
    }
    
    var lastName: String {
        
        return _lastName
    }
    
    var username: String {
        
        return _username
    }
    
    var postKey: String {
        
        return _postKey
    }
    
    //CREATE AN INITIALIZER FOR WHENEVER YOU CREATE A NEW POST
    init(postDescription: String, postImageUrl: String?, firstName: String) {
        
        self._postDescription = postDescription
        self._postImageUrl = postImageUrl
        self._firstName = firstName
    }
    
    //USE AN INITIALIZER TO CONVERT THE DATA THAT COMES FROM FIREBASE INTO SOMETHING WE CAN READ, A DICTIONARY
    //WHEN WE DOWNLOAD DATA FROM FIREBASE, WE MAKE A NEW POST OBJECT AND WE PASS IN THE DICTIONARY 
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        
        //Dictionaries can't guarantee value
        
        if let likes = dictionary["likes"] as? Int {
            
            self._likes = likes
        }
        
        if let dislikes = dictionary["dislikes"] as? Int {
            
            self._dislikes = dislikes
        }
        
        if let postImgUrl = dictionary["imageUrl"] as? String {
            
            self._postImageUrl = postImgUrl
        }
        
        if let desc = dictionary["postDescription"] as? String {
            
            self._postDescription = desc
        }
        
        if let firstName = dictionary["firstname"] as? String {
            
            self._firstName = firstName
        }
        
        if let lastName = dictionary["lastname"] as? String {
            
            self._lastName = lastName
        }
        
        if let username = dictionary["username"] as? String {
            
            self._username = username
        }
        
        //Grab a reference to the firebase post
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
    }
    
    //ADJUST LIKES
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            
            _likes = _likes + 1
            
        } else {
            
            _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)  //setValue replaces it with the value
    }
    
    //ADJUST DISLIKES
    func adjustDislikes(addDislike: Bool) {
        
        if addDislike {
            
            _dislikes = _dislikes + 1
            
        } else {
            
            _dislikes = _dislikes - 1
        }
        
        _postRef.childByAppendingPath("dislikes").setValue(_dislikes)  //setValue replaces it with the value
    }
}