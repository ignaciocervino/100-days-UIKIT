//
//  FileManagerHandler.swift
//  NotesApp
//
//  Created by Ignacio Cervino on 27/02/2023.
//

import Foundation

protocol FileManagerHandling {
    func saveNote(_ note: Note)
    func retrieveNotes() -> [Note]
}

public final class FileManagerHandler: FileManagerHandling {
    private let fm = FileManager.default
    private let pathValue = "notes.json"

    private func getDocumentsDirectory() -> URL {
        let paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func saveNote(_ note: Note) {
        let path = getDocumentsDirectory().appending(path: pathValue)
        // First get previous data
        var notes = retrieveNotes()
        notes.append(note)
        
        guard let encodedNotes = try? JSONEncoder().encode(notes) else { return }
        do {
            try encodedNotes.write(to: path, options: [])
        } catch {
            assertionFailure("Could not write the note.")
        }
    }

    func retrieveNotes() -> [Note] {
        let path = getDocumentsDirectory().appending(path: pathValue)
        do {
            let note = try Data(contentsOf: path)
            return try JSONDecoder().decode([Note].self, from: note)
        } catch {
            print("Decoding Error : \(error)")
            return [Note]()
        }
    }
}
