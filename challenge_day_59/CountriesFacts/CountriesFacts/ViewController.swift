//
//  ViewController.swift
//  CountriesFacts
//
//  Created by Ignacio Cervino on 17/02/2023.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

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
        } catch {
            fatalError("Error: \(error)")
        }
    }


}

