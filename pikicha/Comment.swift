//
//  Comment.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/27.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    
    var likes : Int!
    var commentId: String!
    var postId: String!
    var userId: String!
    var commentText: String

    var commentDate: NSNumber
    var ref: FIRDatabaseReference!
    var key: String = ""
  
    
    
    
    
    
    init(commentId: String,userId: String,commentText: String,postId: String, commentImageUrl: String, commentDate: NSNumber, key: String = "" ) {
        self.commentId = commentId
        self.postId = postId
        self.commentDate = commentDate
        self.commentText = commentText

        self.userId = userId
        self.ref = FIRDatabase.database().reference()
        // self.type  = type.rawValue
        
    }
    
    
    
    init(snapshot: FIRDataSnapshot!) {
        self.commentId = (snapshot.value! as! NSDictionary)["commentId"] as! String
        self.postId = (snapshot.value! as! NSDictionary)["postID"] as! String
        self.commentDate = (snapshot.value! as! NSDictionary)["commentDate"] as! NSNumber
        self.commentText = (snapshot.value! as! NSDictionary)["commentText"] as! String

        self.userId = (snapshot.value! as! NSDictionary)["userID"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
      
    }
    
    
    func toAnyObject() -> [String: Any] {
        
        return ["postID": self.postId,"commentId": self.commentId, "commentDate": self.commentDate, "commentText": self.commentText, "userID": self.userId ]
        
    }

}
