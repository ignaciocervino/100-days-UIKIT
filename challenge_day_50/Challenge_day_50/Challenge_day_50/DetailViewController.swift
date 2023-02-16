//
//  DetailViewController.swift
//  Challenge_day_50
//
//  Created by Ignacio Cervino on 16/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    var selectedImage: String?
    var labelValue: String?
    var selectedIndex: Int?
    let photoPersistence: PhotoPersisting = PhotoPersistence()

    override func viewDidLoad() {
        super.viewDidLoad()
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.changeName(_:)))
        label.addGestureRecognizer(tap)

        guard let imageToLoad = selectedImage, let labelValue = labelValue else { return }
        let path = getDocumentsDirectory().appendingPathComponent(imageToLoad)
        image.image = UIImage(contentsOfFile: path.path)
        label.text = labelValue
    }

    @objc private func changeName(_ sender: UITapGestureRecognizer? = nil) {
        let ac = UIAlertController(title: "Rename caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newCaption = ac?.textFields?[0].text else { return }
            self?.label.text = newCaption
            self?.labelValue = newCaption
            self?.save()
        })
        present(ac, animated: true)
    }

    private func save() {
        guard let caption = labelValue, let image = selectedImage, let index = selectedIndex else { return }
        let newPhoto = Photo(caption: caption, image: image)
        var photos = photoPersistence.loadPhotos()
        photos[index] = newPhoto
        photoPersistence.save(photos: photos)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] // Returns the documents directory
    }
}
