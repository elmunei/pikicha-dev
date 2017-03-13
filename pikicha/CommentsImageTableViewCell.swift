//
//  CommentsImageTableViewCell.swift
//  pikicha
//
//  Created by Elvis Tapfumanei on 2017/02/27.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit

class CommentsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentText: UILabel!
   
    
    var netService = NetworkingService()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.username.text = ""
        self.commentText.text = ""
        
        
    }
    
    func configureCell(comment: Comment){
        
        
        netService.fetchPostUserInfo(uid: comment.userId) { (user) in
            if let user = user {
                self.userImage.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                self.username.text = user.getFullName()
                
            }
        }
        
        
        
        self.commentText.text = comment.commentText
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(comment.commentDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            dateLabel.text = "now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute! == 0 {
            dateLabel.text = "\(differenceOfDate.second!)secs."
            
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            dateLabel.text = "\(differenceOfDate.minute!)mins."
            
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            dateLabel.text = "\(differenceOfDate.hour!)hrs."
            
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            dateLabel.text = "\(differenceOfDate.day!)dys."
            
        }else if differenceOfDate.weekOfMonth! > 0 {
            dateLabel.text = "\(differenceOfDate.weekOfMonth!)wks."
            
        }
        
        
    }
    
    
    
}
