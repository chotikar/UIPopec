//
//  NewsCell.swift
//  UIPSOPEC
//
//  Created by Chotikar on 2/28/2560 BE.
//  Copyright © 2560 Senior Project. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    let scWid = UIScreen.main.bounds.width
    let scHei = UIScreen.main.bounds.height
    
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UITextView!
    @IBOutlet weak var newsSubtitle: UITextView!
    
    
    override func awakeFromNib() {
        newsTitle.textColor = UIColor.white
        newsTitle.font = UIFont.boldSystemFont(ofSize: 14)
        newsTitle.textAlignment = .left
        newsTitle.text = "Title"
//        newsTitle.scrollsToTop = false
        newsSubtitle.textColor = UIColor.black
        newsSubtitle.font = UIFont.systemFont(ofSize: 8)
        newsSubtitle.textAlignment = .left
        newsSubtitle.text = "Sub Title"
//        newsSubtitle.scrollsToTop = false
    }
//
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

