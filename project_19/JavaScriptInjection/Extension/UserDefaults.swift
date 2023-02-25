//
//  UserDefaults.swift
//  Extension
//
//  Created by Ignacio Cervino on 25/02/2023.
//

import Foundation

protocol UserDefaultsManaging {
    func saveJsToUserDefaults(with name: String, using script: String?)
    func retrieveScript(with name: String) -> String
    func getScriptNames() -> [String]
}

class UserDefaultsManager: UserDefaultsManaging {
    let defaults = UserDefaults.standard
    private let userDefaultsKey = "scripts"

    func saveJsToUserDefaults(with name: String, using script: String?) {
        guard let script = script, !script.isEmpty else { return }

        let saveItem = [name: script]
        defaults.set(saveItem, forKey: userDefaultsKey)
    }

    func retrieveScript(with name: String) -> String {
        let savedScripts = defaults.object(forKey: userDefaultsKey) as? [String: String] ?? [String: String]()
        return savedScripts[name] ?? ""
    }

    func getScriptNames() -> [String] {
        let savedScripts = defaults.object(forKey: userDefaultsKey) as? [String: String] ?? [String: String]()
        return Array(savedScripts.keys)
    }
}
