//
//  ATitleButtonTableViewCell.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/30/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

class TitleButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
