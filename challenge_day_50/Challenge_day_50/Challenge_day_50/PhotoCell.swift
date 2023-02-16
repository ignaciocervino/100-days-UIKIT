//
//  PhotoCellTableViewCell.swift
//  Challenge_day_50
//
//  Created by Ignacio Cervino on 15/02/2023.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
