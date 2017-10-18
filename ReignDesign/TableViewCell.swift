//
//  TableViewCell.swift
//  ReignDesign
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TableViewCell : MGSwipeTableCell {

    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
