//
//  MessageTableViewCell.swift
//  ParseChat
//
//  Created by Yale Thomas on 5/21/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    weak var myMessage: Message?

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var identiconView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithMessage(mess: Message) {
        myMessage = mess
        
        if (myMessage == nil) {
            return;
        }
        
        if let name = myMessage?.user!.name {
            usernameLabel.text = name
            identiconView.image = IGIdenticon.identiconWithString(name, size: 50.0)
        }
        
        if let text = myMessage?.text {
            messageLabel.text = text
        }
        
        //TODO: use the location to show the friend's status
        var locationStr = ""
        locLabel.text = ""
        if let loc = myMessage?.location {
            if (myMessage!.text == nil) {
                locLabel.text = loc
            } else {
                locLabel.text = ""
            }
        }

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
