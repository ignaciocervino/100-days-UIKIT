//
//  ViewController.swift
//  CountriesFacts
//
//  Created by Ignacio Cervino on 17/02/2023.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    var flags = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getContries()
        title = "Countries By Ignacio Cerviño"
    }

    // Consume endpoint
    func getContries() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            fatalError("Invalid URL")
        }
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url) {
                self.parse(data)
            }
        }
    }

    private func parse(_ json: Data) {
        let decoder = JSONDecoder()
        do {
            let jsonCountries = try decoder.decode([Country].self, from: json)
            countries = jsonCountries
            loadFlags()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("Error: \(error)")
        }
    }

    private func loadFlags() {
        for i in countries {
            guard let url = URL(string: i.flags.png), let image = loadFlagImage(url: url)  else { continue }
            flags.append(image)
        }
    }

    // Table view methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            fatalError("Cannot dequeue Country Cell")
        }

        let currentCountry = countries[indexPath.row]
        cell.flagLabel.text = currentCountry.name
        cell.flagImage.image = flags[indexPath.row]

        return cell
    }

    private func loadFlagImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }


}

