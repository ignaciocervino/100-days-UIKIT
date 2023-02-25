//
//  MainTableViewController.swift
//  Extension
//
//  Created by Ignacio Cervino on 25/02/2023.
//

import UIKit

class MainTableViewController: UITableViewController {
    var scriptNames = ["Empty"]
    let defaults: UserDefaultsManaging = UserDefaultsManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select a Script"
        scriptNames += defaults.getScriptNames()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scriptNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptName", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = scriptNames[indexPath.row]

        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Script") as? ActionViewController {
            vc.defaultScriptName = scriptNames[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
