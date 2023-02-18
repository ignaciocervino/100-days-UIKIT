//
//  Countrie.swift
//  CountriesFacts
//
//  Created by Ignacio Cervino on 17/02/2023.
//

import Foundation

// MARK: - Country
struct Country: Codable {
    let name, capital: String
    let population: Int
//    let flags: Flags
}

// MARK: - Flags
struct Flags: Codable {
    let svg: String
    let png: String
}
