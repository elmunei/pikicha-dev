//
//  PostImageTableViewCell.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/22.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class PostImageTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var netService = NetworkingService()
    
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    
//    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likePostAction(_ sender: UIButton) {
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.username.text = ""
        self.postText.text = ""
        
    }
    
    var postID: String!
    
  
    @IBAction func likePressed(_ sender: Any) {
   
        self.likeBtn.isEnabled =  false
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String: AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
                
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.numberOfLikes.text = "\(count) likes"
                                    
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeBtn.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.likeBtn.isEnabled = true
                                }
                                
                                
                            }
                            
                        })
                    }
                    
                })
                
            }
        })
        
        ref.removeAllObservers()
    }
    @IBAction func unlikePressed(_ sender: Any) {
   
        self.unlikeBtn.isEnabled = false
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String: AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: {(error, reff) in
                                
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.numberOfLikes.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes": count])
                                            } else {
                                                self.numberOfLikes.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes": 0])
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                }
                                
                            })
                            self.likeBtn.isHidden = false
                            self.unlikeBtn.isHidden = true
                            self.unlikeBtn.isEnabled = true
                            break
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }

    
    func configureCell(post: Post) {
    
        
        self.postImage.sd_setImage(with: URL(string: post.postImageUrl ), placeholderImage: UIImage(named: "addphoto"))
        
      
        netService.fetchPostUserInfo(uid: post.userId) { (user) in
            if let user = user {
                self.userImage.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
           
                
                self.username.text = user.getFullName()
 
                }
        }
        
            netService.fetchNumberOfComments(postId: post.postId) { (numberOfComments) in
                self.numberOfComments.text = "\(numberOfComments) Comments"
            
            }
        
            self.postText.text = post.postText
        
            let fromDate = NSDate(timeIntervalSince1970: TimeInterval(post.postDate))
            let toDate = NSDate()
        
        
        let differenceOfDate = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: fromDate as Date, to: toDate as Date)
        
        if differenceOfDate.second! <= 0 {
            dateLabel.text = "now"
        }else if differenceOfDate.second! > 0 && differenceOfDate.minute! == 0 {
            dateLabel.text = "\(differenceOfDate.second!)secs ago"
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            dateLabel.text = "\(differenceOfDate.minute!)mins ago"
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            dateLabel.text = "\(differenceOfDate.hour!)hrs ago"
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            dateLabel.text = "\(differenceOfDate.day!)days ago"
        }else if differenceOfDate.weekOfMonth! > 0 {
            dateLabel.text = "\(differenceOfDate.weekOfMonth!)weeks ago"
        }


       
        
    }
    
}
