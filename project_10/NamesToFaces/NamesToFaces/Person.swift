//
//  Person.swift
//  NamesToFaces
//
//  Created by Ignacio Cervino on 13/02/2023.
//

import UIKit

class Person: NSObject, NSCoding {
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

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "name")
    }
}
