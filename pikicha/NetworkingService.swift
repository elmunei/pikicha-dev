//
//  NetworkingService.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/21.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import Firebase
import EZLoadingActivity
import FBSDKLoginKit

struct NetworkingService {
    
    var databaseRef: FIRDatabaseReference! {
    
        return FIRDatabase.database().reference()
    
    }
    
    
    var storageRef: FIRStorageReference! {
    
        return FIRStorage.storage().reference()
    
    }
    
    
    
    func signUp (firstname: String, lastname: String, email: String, password: String, pictureData: Data, country: String) {
    
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                
                    let alert = SCLAlertView()
                    _ = alert.showWarning("⛔️", subTitle: error.localizedDescription)
                    
            
            } else {
            
            
                self.setUserInfo(user: user, firstname: firstname, lastname: lastname, pictureData: pictureData, password: password, country: country)
                
            }
        })
        
     
    }
    
    
    private func setUserInfo (user: FIRUser!, firstname: String, lastname: String, pictureData: Data, password: String, country: String) {
        
        let profilePhotoPath = "profileImage\(user.uid)image.jpg"
        let profilePictureRef = storageRef.child(profilePhotoPath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        profilePictureRef.put(pictureData, metadata: metaData) { (newMetaData, error) in
            if let error = error {
                let alert = SCLAlertView()
                _ = alert.showError("⛔️", subTitle: error.localizedDescription)
                
            } else {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = "\(firstname) \(lastname)"
                
                if let url = newMetaData?.downloadURL() {
                    changeRequest.photoURL = url
                
                }
            
                 changeRequest.commitChanges(completion: { (error) in
                    
                    if error == nil {
                        
                        self.saveUserInfoToDB(user: user, firstname: firstname, lastname: lastname, password: password,country: country)
                        
                    } else {
                    
                        let alert = SCLAlertView()
                        _ = alert.showError("⛔️", subTitle: error!.localizedDescription)
                    
                    
                    }
                    
                    
                    
                 })
                
            }
        }
    
    }
    
    
    private func saveUserInfoToDB (user: FIRUser!, firstname: String, lastname: String, password: String, country: String) {
    
        EZLoadingActivity.show("Loading...", disableUI: true)
        
            let userRef = databaseRef.child("users").child(user.uid)
        let newUser = User(email: user.email!, firstname: firstname, lastname: lastname, uid: user.uid, profilePictureUrl: String(describing: user.photoURL!), country: country)
        
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            
            if error == nil {
             EZLoadingActivity.hide(true, animated: false)
                
                print("\(firstname) \(lastname) has been signed up successfully")
            
            } else {
            EZLoadingActivity.hide()
                let alert = SCLAlertView()
                _ = alert.showError("⛔️", subTitle: error!.localizedDescription)
            
            
            }
        }
        
        self.signIn(email: user.email!, password: password)
    
    }
    
    
    func signIn (email: String, password: String) {
        
       
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil {
                
                if let user = user {
                   EZLoadingActivity.hide(true, animated: false)
                    print("\(user.displayName!) has logged in successfully")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.takeToHome()
                    
                }
                
            } else {
                EZLoadingActivity.hide()
                let alert = SCLAlertView()
                _ = alert.showError("⛔️", subTitle: error!.localizedDescription)
                
            }
            
            
            
        })
        
    }
    


    
    func fetchGuestUser(ref: FIRDatabaseReference!, completion: @escaping (User?) -> ()) {
        
        
       ref.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user = User(snapshot: currentUser)
        
            completion(user)
        
            
//            self.downloadImageFromFirebase(urlString: user.profilePictureUrl)
        
        }) { (error) in
             EZLoadingActivity.hide()
            print(error.localizedDescription)
        }
        
        
    }
    
    
    func fetchPosts(completion: @escaping ([Post]) ->()) {

    let postsRef = databaseRef.child("posts")
        postsRef.observe(.value, with: { (posts) in
            
            var resultArray = [Post]()
            for post in posts.children {
                
               
                let post = Post(snapshot: post as! FIRDataSnapshot)
                    resultArray.append(post)
                
            }
            
            completion(resultArray)
            
            
        }) { (error) in
             EZLoadingActivity.hide()
            print(error.localizedDescription)
        }
        
    
    
    }
    
    func fetchAllComments(postId: String, completion: @escaping ([Comment])->()){
        
        let commentsRef = databaseRef.child("comments").queryOrdered(byChild: "postID").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (comments) in
            
            var resultArray = [Comment]()
            for comment in comments.children {
                
                let comment = Comment(snapshot: comment as! FIRDataSnapshot)
                resultArray.append(comment)
            }
            completion(resultArray)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func fetchNumberOfComments(postId: String, completion: @escaping (Int)->()){
        
        let commentsRef = databaseRef.child("comments").queryOrdered(byChild: "postID").queryEqual(toValue: postId)
        
        commentsRef.observe(.value, with: { (comments) in
            
            completion(Int(comments.childrenCount))
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    
        
    func fetchPostUserInfo (uid: String, completion: @escaping (User?)-> ()) {
        
        
        let userRef = databaseRef.child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user = User(snapshot: currentUser)
            completion(user)
            
            
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
    }
    
    
    func fetchAllUsers(completion: @escaping([User]) -> Void) {
       
        let usersRef = databaseRef.child("users")
        usersRef.observe(.value, with: { (users) in
            
            var resultArray = [User]()
            for user in users.children {
                
                let user = User(snapshot: user as! FIRDataSnapshot)
                let currentUser = FIRAuth.auth()!.currentUser!
                
                if user.uid != currentUser.uid {
                    
                    resultArray.append(user)
                }
                
                    completion(resultArray)
            }
            
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
    }
    
    func fetchCurrentUser(completion: @escaping (User?)-> ()) {
       
        let currentUser = FIRAuth.auth()!.currentUser!
        let currentUserRef = databaseRef.child("users").child(currentUser.uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
             let user = User(snapshot: currentUser)
            completion(user)
            
        
         
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func saveCommentToDB(comment: Comment, completed: @escaping ()->Void){
        
        let postRef = databaseRef.child("comments").childByAutoId()
        postRef.setValue(comment.toAnyObject()) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Comment saved successfuly", closeButtonTitle: "Done", duration: 4, colorStyle: UIColor(colorWithHexValue: 0x3D5B94), colorTextButton: UIColor.white)
                completed()
            }
        }
        
    }
    

    func logout(completion: () -> ()) {
        FBSDKLoginManager().logOut()
        if FIRAuth.auth()!.currentUser != nil {
            
            do {
                
                try FIRAuth.auth()?.signOut()
                EZLoadingActivity.showWithDelay("Loading...", disableUI: true, seconds: 2)
                completion()
            } catch let error  {
                print("Failed to logout user: \(error.localizedDescription)")
                
            }
        }
        
        
        
    }
    
    func downloadImageFromFirebase(urlString: String, completion: @escaping (UIImage?)-> ()) {
        
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                
            } else {
                
                if let data = imageData {
                    completion(UIImage(data:data))
                }
                
            }
            
        }
    }
    
    func savePostToDb(post: Post, completed: ()-> Void) {
        let postRef = databaseRef.child("posts")
        postRef.setValue(post.toAnyObject()) {(error,ref) in
            if let error = error {
                print(error.localizedDescription)
            
            } else {
            
                let alertView = SCLAlertView()
                _ = alertView.showSuccess("Success", subTitle: "Post was saved successfully", /*closeButtonTitle: "Done",*/ duration: 1, colorStyle: UIColor(colorWithHexValue: 0x3D5894), colorTextButton: UIColor.white)
                
               
            
            }
        
        
        
        }
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
     
    
    }
    
    func uploadImageToFirebase(postId: String,imageData: Data, completion: @escaping (URL )-> ()) {
        
       let postImagePath = "postImages/\(postId)image.jpeg"
       let postImageRef = storageRef.child(postImagePath)
       let postImageMetadata = FIRStorageMetadata()
       postImageMetadata.contentType = "image/jpeg"
        
        
       postImageRef.put(imageData, metadata: postImageMetadata) { (newPostImageMD, error) in
        if let error = error {
            print(error.localizedDescription)
        
        }else {
            if let postImageURL = newPostImageMD?.downloadURL() {
            completion(postImageURL)
            
            
            }
        }
        }
    }
}



