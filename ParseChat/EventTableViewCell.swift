//
//  EventTableViewCell.swift
//  ParseChat
//
//  Created by Yale Thomas on 5/21/15.
//  Copyright (c) 2015 Rachana Bedekar. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    var myEvent: EventGroup?
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithEvent(event: EventGroup) {
        myEvent = event
        if let titleText = myEvent?.groupID {
            nameLabel.text = titleText
        }
        
    }

}
