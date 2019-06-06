//
//  TrackTableViewCell.swift
//  Kids Tunes
//
//  Created by Zack Walkingstick on 5/21/19.
//  Copyright © 2019 Assemble. All rights reserved.
//

import UIKit

protocol TrackTableViewCellDelegate {
    func didSelectPauseButton(cell: UITableViewCell)
}

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var favoritedImageView: UIImageView!
    @IBOutlet weak var contentContainerButton: UIButton!
    
    var delegate: TrackTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        delegate?.didSelectPauseButton(cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackTitleLabel.textColor = UIColor(named: "AMK-dark-blue")
        pauseButton.isHidden = true
        favoritedImageView.isHidden = true
    }
}
