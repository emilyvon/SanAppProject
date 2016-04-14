//
//  PostCell.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/19/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    //OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikeImage: UIImageView!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBOutlet weak var firstNameOutlet: UILabel!
//    @IBOutlet weak var lastNameOutlet: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    //
    
    
    
    //VARIABLES
    var post: Post!
    
    //Store an Alamofire request, because we may need to cancel it
    var request: Request?
    
    var likeRef: Firebase!
    var dislikeRef: Firebase!
    

    
    //
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(likeTap)
        likeImage.userInteractionEnabled = true
        
        let dislikeTap = UITapGestureRecognizer(target: self, action: #selector(dislikeTapped(_:)))
        dislikeTap.numberOfTapsRequired = 1
        dislikeImage.addGestureRecognizer(dislikeTap)
        dislikeImage.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        postImage.clipsToBounds = true
        
        likeImage.layer.cornerRadius = likeImage.frame.size.width / 2
        likeImage.clipsToBounds = true
        
        dislikeImage.layer.cornerRadius = dislikeImage.frame.size.width / 2
        dislikeImage.clipsToBounds = true
    }
    
    
    
    //
    
    
    
    //FUNCTIONS
    func configureCell(post: Post, img: UIImage?) {
        
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        dislikeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dislikes").childByAppendingPath(post.postKey)

        print(post.postKey)

        self.descriptionText.text = post.postDescription
        self.likesLabel.text = "\(post.likes)"
        self.dislikesLabel.text = "\(post.dislikes)"
        self.firstNameOutlet.text = post.firstName
        
        //Initiate downloading images
        if post.postImageUrl != nil {
            
            if img != nil {
                
                //If there is an imageUrl, get an image from the cache or download it to it

                self.postImage.image = img
                
            } else {
                
                //Make a request
                request = Alamofire.request(.GET, post.postImageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        
                        let img = UIImage(data: data!)!
                        self.postImage.image = img
                        
                        //Add it to the cache
                        PostsVC.imageCache.setObject(img, forKey: self.post.postImageUrl!)
                    }
                })
            }
            
        } else {
            
            self.postImage.hidden = true
        }
        
        //How to manage the like image
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                
                //This means we have not liked this specific post
                self.likeImage.image = UIImage(named: "heart-empty")
                
            } else {
                
                self.likeImage.image = UIImage(named: "heart-full")
            }
        })
        
            //How to manage the dislike image
            dislikeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
            if (snapshot.value as? NSNull) != nil {
        
            //This means we have not liked this specific post
            self.dislikeImage.image = UIImage(named: "heart-empty")
        
            } else {
        
            self.dislikeImage.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if (snapshot.value as? NSNull) != nil {
                
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)  //It saves the reference as true to a specific user
                
            } else {
                
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()  //It removes the reference
            }
        })
    }
    
    func dislikeTapped(sender: UITapGestureRecognizer) {
    
        dislikeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
    
            if (snapshot.value as? NSNull) != nil {
    
                self.dislikeImage.image = UIImage(named: "heart-full")
                self.post.adjustDislikes(true)
                self.dislikeRef.setValue(true)  //It saves the reference as true to a specific user
    
            } else {
    
                self.dislikeImage.image = UIImage(named: "heart-empty")
                self.post.adjustDislikes(false)
                self.dislikeRef.removeValue()  //It removes the reference
            }
        })
    }
    
    func postToFirebase(imgUrl: String?) {
        
        let user: Dictionary <String, String> = [
            
            "firstname": firstNameOutlet.text!
        ]
        
        let firebasePost = DataService.ds.REF_USER_CURRENT.childByAutoId()
        firebasePost.setValue(user)
    }

}


