//
//  Person.swift
//  NamesToFaces
//
//  Created by Ignacio Cervino on 13/02/2023.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    override init() {
        name = ""
        image = ""
    }

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
