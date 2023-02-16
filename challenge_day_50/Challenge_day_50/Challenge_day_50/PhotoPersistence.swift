//
//  PhotoPersistance.swift
//  Challenge_day_50
//
//  Created by Ignacio Cervino on 16/02/2023.
//

import Foundation

protocol PhotoPersisting {
    func save(photos: [Photo])
    func loadPhotos() -> [Photo]
}

public final class PhotoPersistence: PhotoPersisting {
    let defaults = UserDefaults.standard

    func save(photos: [Photo]) {
        let encoder = JSONEncoder()
        if let photoData = try? encoder.encode(photos) {
            defaults.set(photoData, forKey: "photos")
        }
    }

    func loadPhotos() -> [Photo] {
        let decoder = JSONDecoder()
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            if let decodedPhotos = try? decoder.decode([Photo].self, from: savedPhotos) {
                return decodedPhotos
            }
        }
        return [Photo]()
    }
}
