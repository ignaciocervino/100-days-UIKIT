//
//  ViewController.swift
//  Debugging
//
//  Created by Ignacio Cervino on 22/02/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("I'm inside the viewDidLoad() method.")
        print(1,2,3,4,5, separator: "-")
        print("Some message", terminator: "") // By default the terminator is a linebreak
    }


}

