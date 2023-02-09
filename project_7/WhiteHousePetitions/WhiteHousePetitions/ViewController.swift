//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Ignacio Cervino on 06/02/2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var urlString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        setUpNavigationBar()
    }

    private func loadData() {
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        // In order not to freeze the UI, make the networking in another thread, in background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: self?.urlString ?? "") {
                if let data = try? Data(contentsOf: url) { // Downloading json using Data
                    self?.parse(json: data)
                    return
                }
            }
        }
        showError()
    }

    private func setUpNavigationBar() {
        let creditsItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadPetitions))
        navigationItem.rightBarButtonItems = [filter, creditsItem, reload]
    }

    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc private func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Data comes from: \(urlString)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc private func reloadPetitions() {
        loadData()
        tableView.reloadData()
    }

    @objc private func filterPetitions() {
        let ac = UIAlertController(title: "Filter", message: "Petitions should match: ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Apply", style: .default, handler: { _ in
            guard let filter = ac.textFields?[0].text else { return }
            self.filterArray(by: filter)
            self.petitions = self.filteredPetitions
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter a value"
        }
        present(ac, animated: true)
    }

    private func filterArray(by value: String) {
        filteredPetitions = petitions.filter { $0.title.contains(value) }
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }


    // Table methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

