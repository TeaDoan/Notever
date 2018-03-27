//
//  DisplayNoteTableViewCell.swift
//  Note
//
//  Created by Thao Doan on 3/22/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

class DisplayNoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteContentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
