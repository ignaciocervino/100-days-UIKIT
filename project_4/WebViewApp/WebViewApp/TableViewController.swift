//
//  TableTableViewController.swift
//  WebViewApp
//
//  Created by Ignacio Cervino on 03/02/2023.
//

import UIKit

class TableViewController: UITableViewController {
    var websites = ["apple.com", "google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Web View App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            vc.website = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
