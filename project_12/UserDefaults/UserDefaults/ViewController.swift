//
//  ViewController.swift
//  UserDefaults
//
//  Created by Ignacio Cervino on 14/02/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard

        // Save values in UserDefaults
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UserFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")

        defaults.set("Paul Hudson", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")

        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SavedArray")

        let dict = ["Name": "Paul", "Country": "UK"]
        defaults.set(dict, forKey: "SavedDictionary")

        // Get values
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "UserFaceID")

        // For arrays
        let savedArray =  defaults.object(forKey: "SavedArray") as? [String] ?? [String]()

        // For dictionaries
        let savedDictionary = defaults.object(forKey: "SavedDicationary") as? [String: String] ?? [String: String]()
    }


}

