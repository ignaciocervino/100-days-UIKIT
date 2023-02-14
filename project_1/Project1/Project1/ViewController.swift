//
//  ViewController.swift
//  Project1
//
//  Created by Ignacio Cervino on 29/01/2023.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    var  pictureCount = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let itemsArray = try? fm.contentsOfDirectory(atPath: path) {
                for item in itemsArray {
                    if item.hasPrefix("nssl") {
                        self?.pictures.append(item)
                    }
                }
                self?.pictures.sort()
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                let defaults = UserDefaults.standard
                guard let defaultPictureCount = self?.loadPictureCount() else { return }

                self?.pictureCount = defaults.object(forKey: "savedPictures") as? [String: Int] ?? defaultPictureCount
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    private func loadPictureCount() -> [String: Int] {
        var defaultPictureCount = [String: Int]()
        for item in pictures {
            defaultPictureCount[item] = 0
        }
        return defaultPictureCount
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? CustomCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let imageCount = pictureCount[pictures[indexPath.row]]
        cell.nameLabel.text = "\(pictures[indexPath.row]) - times: \(imageCount ?? 0)"
        cell.imageView.image = UIImage(named: pictures[indexPath.row])

        return cell
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//        cell.textLabel?.text = pictures[indexPath.row]
//        return cell
//    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.title = "\(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)

            if let currentValue = pictureCount[pictures[indexPath.row]] {
                pictureCount[pictures[indexPath.row]] = currentValue + 1
            }
            savePictureCount()
        }
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//            vc.selectedImage = pictures[indexPath.row]
//            vc.title = "\(indexPath.row + 1) of \(pictures.count)"
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }

    private func savePictureCount() {
        let defaults = UserDefaults.standard
        defaults.set(pictureCount, forKey: "savedPictures")
    }
}

