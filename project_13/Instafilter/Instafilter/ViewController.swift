//
//  ViewController.swift
//  Instafilter
//
//  Created by Ignacio Cervino on 16/02/2023.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var changeFilterBtn: UIButton!
    @IBOutlet weak var radiusSlider: UISlider!
    var currentImage: UIImage!

    var context: CIContext! // handles rendering
    var currentFilter: CIFilter! // store filter that user activated

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        imageView.alpha = 0
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        UIView.animate(withDuration: 3, animations: { [weak self] in
            self?.imageView.alpha = 1
        })
        currentImage = image

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func intensityChanged(_ sender: UIButton) {
        applyProcessing()
    }

    @IBAction func radiusChanged(_ sender: Any) {
        applyRadius()
    }

    @objc func setFilter(_ action: UIAlertAction) {
        guard currentFilter != nil, currentImage != nil else { return }
        guard let actionTitle = action.title else { return }

        changeFilterBtn.setTitle(actionTitle, for: .normal)

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let error = ImageError(description: "Image not found")
            image(nil, didFinishSavingWithError: error, nil)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:_:)), nil)
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Chose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popoverPresentationController = ac.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
        }

        present(ac, animated: true)
    }

    func applyRadius() {
        guard currentFilter.inputKeys.contains(kCIInputRadiusKey) else { return }
        currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey)

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processImage = UIImage(cgImage: cgImage)
            imageView.image = processImage
        }
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        // value of our slider as the intensity of the current filter
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }

//        if inputKeys.contains(kCIInputRadiusKey) {
//            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
//        }

        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }

        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2) , forKey: kCIInputCenterKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processImage = UIImage(cgImage: cgImage)
            imageView.image = processImage
        }
    }

    @objc func image(_ image: UIImage?, didFinishSavingWithError error: Error?, _ contextInfo: UnsafeRawPointer?) {
        if let error = error as? ImageError {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

