//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Ignacio Cervino on 13/02/2023.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    var currentPerson = Person()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.leftBarButtonItem?.isHidden = true

        authenticate()


    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                // so not to block the main thread, UI goes on main
                DispatchQueue.main.async {
                    if success {
                        self?.navigationItem.leftBarButtonItem?.isHidden = false
                        if let savedPeople = self?.defaults.object(forKey: "people") as? Data {
                            let jsonDecoder = JSONDecoder()

                            do {
                                self?.people = try jsonDecoder.decode([Person].self, from: savedPeople)
                            } catch {
                                print("Failed to load people.")
                            }
                        }
                    } else {
                        // error
                        let ac = UIAlertController(title: "AuthenticationFailed", message: "Your could not be verified, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                            self?.authenticate()
                        }))
                        self?.present(ac, animated: true)
                    }
                }
            }
        }
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()

        dismiss(animated: true) // Dismiss current view controller
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] // Returns the documents directory
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }

        let person = people[indexPath.item]
        cell.nameLabel.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPerson = people[indexPath.item]

        let askAlert = UIAlertController(title: "Rename or Delete", message: "Do you want to rename the person or delete it?", preferredStyle: .alert)
        askAlert.addAction(UIAlertAction(title: "Rename", style: .default, handler: renamePerson))
        askAlert.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
        })
        present(askAlert ,animated: true)


    }

    private func renamePerson(_ action: UIAlertAction) {
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.currentPerson.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac ,animated: true)
    }

    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
}

