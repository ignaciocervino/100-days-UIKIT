//
//  ViewController.swift
//  Animation
//
//  Created by Ignacio Cervino on 17/02/2023.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                break
            default:
                break
            }
        }) { finished in
            sender.isHidden = false // Will not retain cycle
        }

        currentAnimation += 1

        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

