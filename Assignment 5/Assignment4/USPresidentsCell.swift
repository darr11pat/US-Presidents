//
//  MCUCharacterCell.swift
//  MCU
//
//  Created by Darshan Patil on 11/7/16.
//  Copyright © 2016 Northern Illinois University. All rights reserved.
//

import UIKit

class USPresidentsCell: UITableViewCell {

    @IBOutlet weak var presidentImageView: UIImageView!
    @IBOutlet weak var presidentNameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Do any additional setup after loading the view.
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
