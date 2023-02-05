//
//  ViewController.swift
//  Challenge_Day_32
//
//  Created by Ignacio Cervino on 05/02/2023.
//

import UIKit

class ViewController: UITableViewController {

    private var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        title = "Your Shopping List"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToAdd)), UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(shareList))]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearList))
    }

    @objc private func promptToAdd() {
        let ac = UIAlertController(title: "Add an item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let addAction = UIAlertAction(title: "Add to list", style: .default) { [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.addNewItem(item)
        }

        ac.addAction(addAction)
        present(ac, animated: true)
    }

    @objc private func clearList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    @objc private func shareList() {
        let list = shoppingList.joined(separator: "\n")
        let activity = UIActivityViewController(activityItems: [list], applicationActivities: [])
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activity, animated: true)
    }

    private func addNewItem(_ item: String) {
        if !item.isEmpty {
            shoppingList.insert(item, at: 0)

            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Error", message: "Cannot add empty item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

    }

    // Table view functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}

