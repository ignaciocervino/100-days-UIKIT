//
//  DetailViewController.swift
//  WorldFlagChallenge
//
//  Created by Ignacio Cervino on 31/01/2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = currentImage else { return }
        imageView.image = image
        imageView.backgroundColor = .lightGray

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))


        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc private func shareImage() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let text = title else { return }
        let vc = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // So it works in iPad
        present(vc, animated: true)
    }
}
