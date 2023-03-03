//
//  DetailViewController.swift
//  Project1
//
//  Created by Ignacio Cervino on 29/01/2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        guard let imageToLoad = selectedImage else { return }
        imageView.image = UIImage(named: imageToLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let image = addTextToImage(imageView?.image).jpegData(compressionQuality: 0.8), let text = selectedImage else { return }
        let vc = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // So it works in iPad
        present(vc, animated: true)
    }

    /**
     Go back to project 3 and change the way the selected image is shared so that it has some rendered text on top saying “From Storm Viewer”. This means reading the size property of the original image, creating a new canvas at that size, drawing the image in, then adding your text on top.
     */
    private func addTextToImage(_ image: UIImage?) -> UIImage {
        guard let image else { return UIImage() }
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let newImage = renderer.image { ctx in
            // draw code here
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22),
                .paragraphStyle: paragraphStyle
            ]

            let text = "From Storm Viewer"

            let attributedString = NSAttributedString(string: text, attributes: attrs)
            attributedString.draw(with: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), options:  .usesLineFragmentOrigin, context: nil)

            image.draw(at: CGPoint(x: 0, y: 40))
        }

        return newImage
    }

}
