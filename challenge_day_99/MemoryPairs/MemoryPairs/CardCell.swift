//
//  CardCell.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 10/03/2023.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Customize the cell's appearance here
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.lightGray.cgColor

        cardLabel.textColor = UIColor.black
        cardLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}
