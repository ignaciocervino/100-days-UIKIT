//
//  DetailViewController.swift
//  NotesApp
//
//  Created by Ignacio Cervino on 27/02/2023.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var noteTxt: UITextView!

    var note: Note?
    var titleString = "Unknown"
    let fileManager: FileManagerHandling = FileManagerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        addToolBarItems()
    }

    private func addToolBarItems() {
        let delete = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearNote))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareText))
        toolbarItems = [delete, share]
        navigationController?.isToolbarHidden = false
    }

    @objc private func clearNote() {
        noteTxt.text.removeAll()
        title = "Unknown"
    }

    @objc private func shareText() {
        guard let text = noteTxt.text else { return }

        let vc = UIActivityViewController(activityItems: [titleString, text], applicationActivities: [])
        present(vc, animated: true)
    }

    private func updateUI() {
        if let note = note {
            titleString = note.title
            noteTxt.text = note.content
        }
        
        title = titleString
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
    }

    @objc private func addNote() {
        guard !noteTxt.text.isEmpty else {
            let emptyAC = UIAlertController(title: "Cannot save empty note", message: nil, preferredStyle: .alert)
            emptyAC.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(emptyAC, animated: true)
            return
        }

        let ac = UIAlertController(title: "Add a title", message: "Please add a title for this note", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let noteTitle = ac.textFields?[0].text, !noteTitle.isEmpty else {
                let noTitleAC = UIAlertController(title: "Title cannot be empty", message: nil, preferredStyle: .alert)
                noTitleAC.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(noTitleAC, animated: true)
                return
            }

            self?.title = noteTitle
            self?.titleString = noteTitle
            self?.saveNote()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    private func saveNote() {
        note = Note(title: titleString, content: noteTxt.text)
        // We are sure the value is not nil
        fileManager.saveNote(note!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
