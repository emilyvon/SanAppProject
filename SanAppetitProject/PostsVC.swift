//
//  PostsVC.swift
//  SanAppetitProject
//
//  Created by walid amachraa on 3/19/16.
//  Copyright © 2016 wallPrograms. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class PostsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postDescriptionField: UITextField!
    @IBOutlet weak var imageSelectorOutlet: UIImageView!
    
    //Activity indicator
    @IBOutlet weak var activityIndicatorPostPressedOutlet: UIActivityIndicatorView!
    
    
    
    
    //
    
    
    
    
    //VARIABLES
    var posts = [Post]()
    
    //variable for the cache that stores all the image views
    //static makes one instance of it that is globally accessible
    static var imageCache = NSCache()
    
    var imagePicker: UIImagePickerController!
    
    //Not to post the camera image
    var imageSelected = false
    
    
    
    
    //
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Make an estimated row height
        tableView.estimatedRowHeight = 420
        
        //IMAGEPICKER
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        postDescriptionField.delegate = self
        postDescriptionField.returnKeyType = UIReturnKeyType.Done
        
        
        
        
        //
        
        
        
        
        //TALK TO FIREBASE AND UPDATE EVERY TIME A CHANGE IS MADE
        
        //LISTEN TO THE DATA TO UPDATE IT, ANYTIME A VALUE CHANGES, ANYTIME DATA CHANGES
        //IT IS ONLY CALLED WHEN DATA IS CHANGED, IT UPDATES THE UI
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            self.posts = []  //To empty and replace the array to repopulate it with the new data
            
            //PARSE THE DATA FROM A SNAPSHOT FORM TO USABLE DATA
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {  //Grab all the objects from Firebase in the form of FDataSnapshot
                
                //Iterate through it
                for snap in snapshots.reverse() {
                    print("SNAP: \(snap)")
                    
                    //ONCE YOU GET A USABLE DATA, STORE IT IN ITS OWN CLASS TO BE ABLE TO DISPLAY IT ON THE UI OR TO USE IT WHEN NEEDED
                    
                    //Get dictionaries
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {  //Grab the value of the posts, value returns the content of the snapshot
                        
                        let key = snap.key  //Now we have the data, grab the specific key of each post
                        
                        //Create a new post
                        let post = Post(postKey: key, dictionary: postDict)
                        
                        //Add it to the list
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    
    
    //
    
    
    
    //FUNCTIONS FOR THE TABLE VIEW
    
    //A section has rows, rows have cells
    
    //Number of sections in the table view which are repeated
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    //Number of rows in the section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count  //Equal to the total amount of posts
    }
    
    //Each cell in the row we are working on
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Create a new cell for each post
        let post = posts[indexPath.row]
        print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            //Everytime we create a new cell, cancel the request
            //If it does not exist, it's ok, if it exists, cancel it so that it can run a new request if we need to
            cell.request?.cancel()
            
            //Working with images (cache and downloading)
            var img: UIImage?
            
            if let url = post.postImageUrl {
                
                //Use PostsVC and not self because imageCache is globally accessible
                img = PostsVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
            
        } else {
            
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Grab our post
        let post = posts[indexPath.row]
        
        //
        if post.postImageUrl == nil {
            
            return 250
            
        } else {
            
            return tableView.estimatedRowHeight
        }
    }
    
    //IMAGEPICKER FUNCTION
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorOutlet.image = image
        imageSelected = true
    }

    
    
    //ACTIONS
    @IBAction func onImageSelectorTapGesturePressed(sender: UITapGestureRecognizer) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onPostButtonPressed(sender: AnyObject) {
        
        self.postDescriptionField.resignFirstResponder()
        
        if let txt = postDescriptionField.text where txt != "" {
            
            self.activityIndicatorPostPressedOutlet.startAnimating()

            if let img = imageSelectorOutlet.image where imageSelected == true {  //To make sure the picture is not the camera image
                
                let urlStr = "https://post.imageshack.us/upload_api.php"  //For uploading an image
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                //Converting string and json into data (from the api)
                let keyData = "DGW4ZJSL0e061e868c4e679a2dfe516364f7add4".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType:"image/jpg")  //From api
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                }) { encodingResult in
                    
                    //When the upload is done
                    switch encodingResult {
                        
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { response in
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    
                                    if let imgLink = links["image_link"] as? String {
                                        
                                        print("LINK: \(imgLink)")
                                        self.postToFirebase(imgLink)

                                        self.activityIndicatorPostPressedOutlet.stopAnimating()
                                    }
                                }
                            }
                        })
                    case.Failure(let error):
                        print(error)
                        //Print an alert to the screen
                    }
                }
            } else {
                
                self.postToFirebase(nil)
                
                self.activityIndicatorPostPressedOutlet.stopAnimating()
                
                self.postDescriptionField.resignFirstResponder()
            }
        }
    }
    
    
    
    //

    
    
    
    func postToFirebase(imgUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = [
        "postDescription": postDescriptionField.text!,
        "likes": 0,
        "dislikes": 0,
        ]
        
        if imgUrl != nil {
            
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postDescriptionField.text = ""
        imageSelectorOutlet.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        postDescriptionField.resignFirstResponder()
        return true
    }
}



//Add a view controller, choose between taking a picture form the phone, a photo with the phone, or a video with the phone

