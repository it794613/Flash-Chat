//
//  TableViewCell.swift
//  Flash Chat iOS13
//
//  Created by 최진용 on 2022/09/09.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {


    @IBOutlet weak var youAvatar: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var Lable: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height/4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
