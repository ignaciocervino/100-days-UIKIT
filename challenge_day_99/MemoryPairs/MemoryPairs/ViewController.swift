//
//  ViewController.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 09/03/2023.
//

import UIKit

class ViewController: UICollectionViewController {
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = CollectionViewLayout()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the section
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }

        cell.cardLabel.text = items[indexPath.row]

        return cell
    }

}

