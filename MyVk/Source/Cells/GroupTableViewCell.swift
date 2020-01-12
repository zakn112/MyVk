//
//  GroupTableViewCell.swift
//  MyVk
//
//  Created by kio on 29/09/2019.
//  Copyright © 2019 kio. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupeAvatar: AvatarView!
    @IBOutlet weak var groupName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupName.text = nil
        groupeAvatar.image = nil
    }
}
