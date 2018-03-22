//
//  NoteTableViewCell.swift
//  Note
//
//  Created by Thao Doan on 3/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   

    
}
