//
//  CountryCell.swift
//  CountriesFacts
//
//  Created by Ignacio Cervino on 18/02/2023.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
