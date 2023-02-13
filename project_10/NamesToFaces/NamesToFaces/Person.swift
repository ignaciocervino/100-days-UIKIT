//
//  Person.swift
//  NamesToFaces
//
//  Created by Ignacio Cervino on 13/02/2023.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    override init() {
        name = ""
        image = ""
    }
}
