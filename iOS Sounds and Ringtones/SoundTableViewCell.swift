//
//  SoundTableViewCell.swift
//  iOS Sounds and Ringtones
//
//  Created by Carleton Hall on 10/15/16.
//  Copyright © 2016 Carleton Hall. All rights reserved.
//

import UIKit

class SoundTableViewCell: UITableViewCell {
    @IBOutlet var fileNameLabel: UILabel!
    @IBOutlet var filePathLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
