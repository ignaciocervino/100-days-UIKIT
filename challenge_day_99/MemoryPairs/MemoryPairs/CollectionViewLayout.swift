//
//  CollectionViewLayout.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 10/03/2023.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        // Calculate the size of each cell
        let cellWidth = (collectionView.bounds.width - minimumInteritemSpacing * 2) / 3
        let cellHeight = cellWidth

        // Set the size of each cell
        itemSize = CGSize(width: cellWidth, height: cellHeight)

        // Set the spacing between each row and column of cells
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5

        // Set the section insets to center the grid in the collection view
        let insetX = (collectionView.bounds.width - (cellWidth * 3 + minimumInteritemSpacing * 2)) / 2
        let insetY = (collectionView.bounds.height - (cellHeight * 3 + minimumLineSpacing * 2)) / 2
        sectionInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)

        // Add content inset to move cells to the top of the screen
        let topInset = collectionView.bounds.height / 4
        collectionView.contentInset = UIEdgeInsets(top: -topInset, left: 0, bottom: 0, right: 0)
    }
}
