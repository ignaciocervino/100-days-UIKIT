//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Ignacio Cervino on 03/03/2023.
//

import UIKit

enum TextType {
    case top, bottom
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var upperBtn: UIButton!

    var topText: String?
    var bottomText: String?
    var cleanImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Meme Generator"
        setUpButtons()
    }

    private func setUpButtons() {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(getPicture))
        navigationItem.rightBarButtonItem = cameraBtn

        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
        navigationItem.leftBarButtonItem = shareBtn

        let backgroundColor = UIColor.cyan
        bottomBtn.backgroundColor = backgroundColor
        bottomBtn.setTitle("Bottom Text", for: .highlighted)
        bottomBtn.layer.cornerRadius = 5
        bottomBtn.layer.borderWidth = 1
        bottomBtn.layer.borderColor = UIColor.black.cgColor

        upperBtn.backgroundColor = backgroundColor
        upperBtn.setTitle("Top Text", for: .highlighted)
        upperBtn.layer.cornerRadius = 5
        upperBtn.layer.borderWidth = 1
        upperBtn.layer.borderColor = UIColor.black.cgColor
    }

    @objc private func getPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        topText = nil
        bottomText = nil
        cleanImage = nil
        present(picker, animated: true)
    }

    @objc private func shareMeme() {
        guard let image = memeImage.image else {
            let ac = UIAlertController(title: "There is no image!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            return
        }

        let activityController =  UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(activityController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        cleanImage = image
        memeImage.image = image
        dismiss(animated: true)

        askText(textType: .top, presentSecond: true)
    }

    private func addTextToImage(_ image: UIImage?) -> UIImage? {
        guard let image else { return memeImage.image }
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let newImage = renderer.image { ctx in
            // draw code here
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Impact", size: 90) ?? UIFont.systemFont(ofSize: 60),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]

            image.draw(at: CGPoint.zero)

            if let topText {
                let topString = NSAttributedString(string: topText, attributes: attrs)
                topString.draw(at: CGPoint(x: ((image.size.width - topText.size().width) / 2), y: 20))
            }

            if let bottomText {
                let bottomString = NSAttributedString(string: bottomText, attributes: attrs)
                bottomString.draw(at: CGPoint(x: (image.size.width - bottomText.size().width) / 2, y: image.size.height * 0.8))
            }
        }

        return newImage
    }

    @IBAction func bottomBtnAction(_ sender: Any) {
        guard memeImage.image != nil else { return }
        askText(textType: .bottom)
    }

    @IBAction func upperBtnAction(_ sender: Any) {
        guard memeImage.image != nil else { return }
        askText(textType: .top)
    }

    private func askText(textType: TextType, presentSecond: Bool = false) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        ac.addTextField()

        if textType == .top {
            ac.title = "Top text"
            ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
                if let text = ac.textFields?[0].text, !text.isEmpty {
                    self?.topText = text.uppercased()
                }
                self?.memeImage.image = self?.addTextToImage(self?.cleanImage)
                if presentSecond {
                    self?.askText(textType: .bottom)
                }
            }))
        } else if textType == .bottom {
            ac.title = "Bottom text"
            ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
                if let text = ac.textFields?[0].text, !text.isEmpty {
                    self?.bottomText = text.uppercased()
                }
                self?.memeImage.image = self?.addTextToImage(self?.cleanImage)
            }))
        } else {
            return
        }

        present(ac, animated: true)
    }
}

