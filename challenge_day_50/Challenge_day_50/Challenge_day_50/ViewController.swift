//
//  ViewController.swift
//  Challenge_day_50
//
//  Created by Ignacio Cervino on 15/02/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUI()
    }

    private func loadUI() {
        title = "Photo Listing by PU.Cerviño"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    }


    // Objc methods
    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    // ImagePicker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appending(path: imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let photo = Photo(caption: "Unknown", image: imageName)
        photos.append(photo)
        // save()
        tableView.reloadData()

        dismiss(animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] // Returns the documents directory
    }

    // TableViewController methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Could not dequeue PhotoCell.")
        }
        let photo = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)

//        let cellImg : UIImageView = UIImageView(frame: CGRectMake(5, 5, 40, 40))
//        cellImg.image = UIImage(contentsOfFile: path.path)

        cell.photo.image = UIImage(contentsOfFile: path.path)//cellImg.image
        cell.caption.text = photo.caption
        print("caption: \(photo.caption)")
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

//extension UIImage {
//    func getCropRatio() -> CGFloat {
//        return CGFloat(self.size.width / self.size.height)
//    }
//}

