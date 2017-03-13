//
//  Post.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/24.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import Firebase

class Post: NSObject {

//    enum PostType: String {
//        case Image, Text
//    }
    
    var likes : Int!
    var postId: String!
    var userId: String!
    var postText: String
    var postImageUrl: String
    var postDate: NSNumber
    var ref: FIRDatabaseReference!
    var key: String = ""
    var peopleWhoLike: [String] = [String]()
    //var type: String
   
    
    
    
    
    init(postId: String,userId: String,postText: String,likes: Int, postImageUrl: String, postDate: NSNumber, key: String = "" ) {
        self.postId = postId
        self.postDate = postDate
        self.postText = postText
        self.postImageUrl = postImageUrl
        self.userId = userId
        self.ref = FIRDatabase.database().reference()
        self.likes = likes
       // self.type  = type.rawValue
        
    }

    
    
    init(snapshot: FIRDataSnapshot!) {
        self.postId = (snapshot.value! as! NSDictionary)["postID"] as! String
        self.postDate = (snapshot.value! as! NSDictionary)["postDate"] as! NSNumber
        self.postText = (snapshot.value! as! NSDictionary)["postText"] as! String
        self.postImageUrl = (snapshot.value! as! NSDictionary)["postImageUrl"] as! String
        self.userId = (snapshot.value! as! NSDictionary)["userID"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.likes = (snapshot.value! as! NSDictionary)["likes"] as! Int
        //self.type = (snapshot.value! as! NSDictionary)["type"] as! String
    }
    
    
    func toAnyObject() -> [String: Any] {
    
        return ["postID": self.postId, "postDate": self.postDate, "postText": self.postText, "postImageUrl": self.postImageUrl, "userId": self.userId,"likes": self.likes  /*"type": self.type*/]
    
    }
    
}

























