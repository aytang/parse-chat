//
//  ChatTableViewCell.swift
//  ParseChat
//
//  Created by Nicholas Aiwazian on 2/3/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message : Message! {
        didSet {
            if let username = message.authorName {
                nameLabel.text = username
                nameLabel.hidden = false
            }else{
                nameLabel.text = ""
                nameLabel.hidden = true
            }
            
            messageLabel.text = message.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
