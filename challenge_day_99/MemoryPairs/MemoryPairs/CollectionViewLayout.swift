//
//  CollectionViewLayout.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 10/03/2023.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    var numberOfItemsPerRow: CGFloat?

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let numberOfItemsPerRow: CGFloat = numberOfItemsPerRow ?? 2
        let spacing: CGFloat = 5

        // Calculate the size of each cell
        let totalSpacing = (numberOfItemsPerRow + 1) * spacing
        let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        let cellHeight = cellWidth

        // Set the size of each cell
        itemSize = CGSize(width: cellWidth, height: cellHeight)

        // Set the spacing between each row and column of cells
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing

        // Add space between the left and right sides of the screen and the cells
        let leftRightInset = spacing
        sectionInset = UIEdgeInsets(top: spacing, left: leftRightInset, bottom: spacing, right: leftRightInset)
    }
}
