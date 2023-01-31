//
//  ViewController.swift
//  WorldFlagChallenge
//
//  Created by Ignacio Cervino on 31/01/2023.
//

import UIKit

class ViewController: UITableViewController {

    private var flags = [UIImage]()
    private var flagsName = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "World Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadFlags()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = flagsName[indexPath.row]
        content.image = flags[indexPath.row]
        cell.layer.borderWidth = 2.0
        cell.backgroundColor = .lightGray
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.currentImage = flags[indexPath.row]
            vc.title = flagsName[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func loadFlags() {
        let fm = FileManager.default
        let flagsPath = Bundle.main.resourcePath!;
        if let contentOfFlagDirectory = try? fm.contentsOfDirectory(atPath: flagsPath) {
            for item in contentOfFlagDirectory {
                if item.hasSuffix("@2x.png") {
                    // Add as image
                    flags.append(UIImage(named: item) ?? UIImage())
                    var flagName = item
                    flagName.removeLast(7)
                    flagsName.append(flagName.uppercased())
                }
            }
        }
    }
}

