//
//  ViewController.swift
//  NotesApp
//
//  Created by Ignacio Cervino on 27/02/2023.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    let fm: FileManagerHandling = FileManagerHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStaticUI()
        loadNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }

    private func loadStaticUI() {
        title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
    }

    private func loadNotes() {
        DispatchQueue.global(qos: .background).async {
            self.notes = self.fm.retrieveNotes()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func createNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailNote") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notes", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = notes[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailNote") as? DetailViewController {
            vc.note = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

