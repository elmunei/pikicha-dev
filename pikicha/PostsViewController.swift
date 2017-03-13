////
////  PostsViewController.swift
////  pikicha
////
////  Created by Elvis Tapfumanei on 2017/03/09.
////  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class PostsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
//
//    
//    struct CellIdentifier {
//        
//        var postImageCell = "imageCell"
//       
//        
//    }
//    
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    var posts = [Post]()
//    var following = [String]()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    
//    func fetchPosts() {
//        let ref = FIRDatabase.database().reference()
//        
//        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
//            
//            let users = snapshot.value as! [String : AnyObject]
//            
//            for (_,value) in users {
//                if let uid = value["uid"] as? String {
//                    if uid == FIRAuth.auth()?.currentUser?.uid {
//                        if let followingUsers = value["following"] as? [String : String]{
//                            for (_,user) in followingUsers {
//                                self.following.append(user)
//                                
//                            }
//                            
//                        }
//                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
//                        
//                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
//                            
//                            let postsSnap = snap.value as! [String : AnyObject]
//                            
//                            for (_,post) in postsSnap {
//                                if let userID = post["userID"] as? String {
//                                    for each in self.following {
//                                        if each == userID {
//                                            let posst = Post()
//                                            if let likes = post["likes"] as? Int, let desc = post["postText"] as? String, let pathToImage = post["postImageUrl"] as? String, let postID = post["postID"] as? String {
//                                                
//                                                
//                                                posst.likes = likes
//                                                posst.postText = desc
//                                                posst.postImageUrl = pathToImage
//                                                
//                                                posst.postId = postID
//                                                posst.userId = userID
//                                                
//                                                
//                                                
//                                                if let people = post["peopleWhoLike"] as? [String : AnyObject] {
//                                                    for(_,person) in people {
//                                                        posst.peopleWhoLike.append(person as! String)
//                                                    }
//                                                    
//                                                }
//                                                
//                                                self.posts.append(posst)
//                                            }
//                                            
//                                        }
//                                        
//                                    }
//                                    
//                                    self.tableView.reloadData()
//                                    
//                                }
//                                
//                            }
//                            
//                        })
//                    }
//                    
//                }
//                
//                
//            }
//            
//        })
//        
//        ref.removeAllObservers()
//        
//    }
//
//    
//    
//    
//    
//    
//    
//    
//    
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier().postImageCell, for: indexPath) as! PostImageTableViewCell
//        cell.configureCell(post: posts[indexPath.row])
//       
//        cell.postID = self.posts[indexPath.row].postId
//        cell.numberOfLikes.text = "\(self.posts[indexPath.row].likes!) Likes"
//        
//        
//        for person in self.posts[indexPath.row].peopleWhoLike {
//            if person == FIRAuth.auth()!.currentUser!.uid {
//                cell.likeBtn.isHidden = false
//                cell.unlikeBtn.isHidden = true
//                break
//            }
//            
//        }
//        return cell
//        
//        
//    }
//
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
