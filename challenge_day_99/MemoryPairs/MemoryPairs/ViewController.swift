//
//  ViewController.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 09/03/2023.
//

import UIKit

typealias CountriesInfo = [String: String]

class ViewController: UICollectionViewController {
    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var countriesInfo: CountriesInfo?
    var levelRows: Int? = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        loadCountriesInfoFromFile(named: "CountriesInfo") { [weak self] result in
            switch result {
            case .success(let decodedResult):
                self?.countriesInfo = decodedResult
                self?.collectionView.reloadData()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func setupCollectionViewLayout() {
        let collectionViewLayout = CollectionViewLayout()
        collectionViewLayout.numberOfItemsPerRow = CGFloat(levelRows ?? 2)
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func loadCountriesInfoFromFile(named filename: String, bundle: Bundle = .main, completion: @escaping (Result<CountriesInfo, Error>) -> Void) {
        DispatchQueue.global().async {
            guard let url = bundle.url(forResource: filename, withExtension: "json") else {
                let error = NSError(domain: "loadCountriesInfoFromFile", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not find file '\(filename)' in bundle"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let countriesInfo = try JSONDecoder().decode(CountriesInfo.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(countriesInfo))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the section
        guard let levelRows else { return 4 }
        return levelRows * levelRows
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }

        cell.cardLabel.text = countriesInfo?["ar"] ?? "Nigeria"
        cell.cardLabel.adjustsFontSizeToFitWidth = true
        cell.cardLabel.minimumScaleFactor = 0.5
        cell.cardLabel.sizeToFit()

        return cell
    }

}

