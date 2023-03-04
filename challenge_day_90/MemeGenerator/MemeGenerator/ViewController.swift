//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Ignacio Cervino on 03/03/2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Meme Generator"
        createBarButtons()
    }

    private func createBarButtons() {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(getPicture))
        navigationItem.rightBarButtonItem = cameraBtn
    }

    @objc private func getPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)

        memeImage.image = image
    }


}

