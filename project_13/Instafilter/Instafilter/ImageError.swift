//
//  ImageError.swift
//  Instafilter
//
//  Created by Ignacio Cervino on 17/02/2023.
//

import Foundation

public struct ImageError: Error {
    let description: String

    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
