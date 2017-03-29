//
//  ViewController.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/15/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import UIKit
import HMSegmentedControl
import Firebase
import EZLoadingActivity

class HomeViewController: UIViewController {
    
    var usersArray = [User]()
    var postsArray = [Post]()
    var netService = NetworkingService()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchAllUsers()
        fetchAllPosts()
        setSegmentedControl ()
        if segmentedControl.selectedSegmentIndex == 0 {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 592
        }
    }
    
    private func fetchAllUsers() {
        netService.fetchAllUsers { (users) in
            self.usersArray = users
            
            self.collectionView.reloadData()
        }
        
    }
    
    
    
    
    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
        
    }
    
    
    var segmentedControl: HMSegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView! {
    
        didSet {
            collectionView.alpha = 0
        
        }
    
    }
    
    
   
    
    private func fetchAllPosts() {
    
        netService.fetchPosts { (posts) in
            self.postsArray = posts
            self.postsArray.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func commentPostWithImageAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showComments", sender: sender)
        
    }
    
    
   
    
 
    
    
    @IBAction func unwindToHome(storyboardSegue: UIStoryboardSegue) {
    }
    
    func setSegmentedControl () {
        
        segmentedControl = HMSegmentedControl(frame: CGRect(x: 0, y: 99, width: self.view.frame.size.width, height: 60))
        segmentedControl.sectionTitles = ["Favourites", "Explore"]
        segmentedControl.backgroundColor = UIColor(colorWithHexValue: 0x019875)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Medium", size: 18)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentedControl.selectionIndicatorColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionIndicatorLocation = .up
        segmentedControl.addTarget(self, action: #selector(HomeViewController.segmentedControlAction), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentedControl)
        
    }
    
    
    func segmentedControlAction() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            //self.fetchAllPosts()
           
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionView.alpha = 0
                self.tableView.alpha = 1.0
            })

            
        } else {
            //self.fetchAllUsers()
         UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.alpha = 1.0
            self.tableView.alpha = 0
         })
        } 
        
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    struct CellIdentifiers {
        var userCell = "userCell"
        var postImageCell = "imageCell"
        var postTextCell = "textCell"
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
          
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postImageCell, for: indexPath) as! PostImageTableViewCell
            cell.configureCell(post: postsArray[indexPath.row])
        cell.commentButton.tag = indexPath.row
        cell.postID = self.postsArray[indexPath.row].postId
        cell.numberOfLikes.text = "\(self.postsArray[indexPath.row].likes!) Likes"
        
        
        for person in self.postsArray[indexPath.row].peopleWhoLike {
            if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likeBtn.isHidden = true
                cell.unlikeBtn.isHidden = false
                break
            }
            
        }
            return cell
            
      
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return postsArray.count

    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuest" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first{
                let guestVC = segue.destination as! ProfileViewController
                guestVC.ref = usersArray[indexPath.row].ref
                
            }
            
        } else if segue.identifier == "showComments" {
            let sender = sender as? UIButton
            if let indexPath: Int = sender?.tag  {
                let commentsVC = segue.destination as! CommentsTableViewController
                commentsVC.post = self.postsArray[indexPath]
            }
        
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "showGuest", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers().userCell, for: indexPath) as! UserCollectionViewCell
        cell.configureCellForUser(user: self.usersArray[indexPath.row])
        
        return cell
    }
    
}





































