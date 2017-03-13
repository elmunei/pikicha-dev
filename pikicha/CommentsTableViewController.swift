//
//  CommentsTableViewController.swift
//  FirebaseLive
//
//  Created by Frezy Mboumba on 1/15/17.
//  Copyright © 2017 Frezy Mboumba. All rights reserved.
//

import UIKit
import Firebase

class CommentsTableViewController: UITableViewController {

    var post: Post!
    var commentsArray = [Comment]()
    var netService = NetworkingService()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 592
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        netService.fetchAllComments(postId: post.postId) { (comments) in
            self.commentsArray = comments
            self.commentsArray.sort(by: { (comment1, comment2) -> Bool in
                Int(comment1.commentDate) > Int(comment2.commentDate)
            })
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentsArray.count
    }
    
    
    @IBAction func addCommentAction(_ sender: Any) {
        performSegue(withIdentifier: "addComment", sender: self)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                    let cell = tableView.dequeueReusableCell(withIdentifier: "commentImageCell", for: indexPath) as! CommentsImageTableViewCell
            cell.configureCell(comment:commentsArray[indexPath.row])
            return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"{
            let addCommentVC = segue.destination as! AddCommentViewController
            addCommentVC.postId = post.postId
        }
    }

   }
