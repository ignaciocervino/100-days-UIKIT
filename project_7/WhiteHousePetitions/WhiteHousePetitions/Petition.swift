//
//  Petition.swift
//  WhiteHousePetitions
//
//  Created by Ignacio Cervino on 06/02/2023.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
