//
//  ViewController.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 09/03/2023.
//

import UIKit

typealias CountriesInfo = [String: String]

class ViewController: UICollectionViewController {
    var countriesInfoTuple: [(String, String)]? = [] // store all the data
    var currentLevelTuple: [(String, String)] = []
    var randomLevelInfo: [String] = [] // current level countries/codes
    var gameRows = 2 // start with 2x2 game

    var matchedPairs: [IndexPath] = [] // Define the matchedPairs array
    var shouldMatchValue: String = ""

    var selectedItem: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        loadCountriesInfoFromFile(named: "CountriesInfo") { [weak self] result in
            switch result {
            case .success(let decodedDictionary):
                self?.countriesInfoTuple = decodedDictionary.map { ($0, $1) }
                self?.countriesInfoTuple?.shuffle()
                self?.setupGameArray()
                self?.collectionView.reloadData()

            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }

    }

    private func setupGameArray() {
        guard let countriesInfoTuple else { return }

        currentLevelTuple = Array(countriesInfoTuple.prefix(gameRows))

        randomLevelInfo = currentLevelTuple.flatMap { [$0.0, $0.1] }

        var uniqueRandomLevelItems = Set<String>()

        while uniqueRandomLevelItems.count < randomLevelInfo.count {
            let randomIndex = Int.random(in: 0..<randomLevelInfo.count)
            let randomItem = randomLevelInfo[randomIndex]
            uniqueRandomLevelItems.insert(randomItem)
        }

        randomLevelInfo = Array(uniqueRandomLevelItems)
    }

    private func setupCollectionViewLayout() {
        let collectionViewLayout = CollectionViewLayout()
        collectionViewLayout.numberOfItemsPerRow = CGFloat(gameRows)
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
        return gameRows * gameRows
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }

        guard !randomLevelInfo.isEmpty else { return cell}

        cell.cardLabel.text = randomLevelInfo[indexPath.row]
        cell.cardView.backgroundColor = .gray
        cell.cardLabel.isHidden = true

        return cell
    }


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }

        let cardValue = randomLevelInfo[indexPath.row]
        guard !matchedPairs.contains(indexPath) else { return }

        cell.cardView.backgroundColor = .orange
        cell.cardLabel.isHidden = false
        switch selectedItem {
        case 0:
            matchedPairs.append(indexPath)
            selectedItem = 1
        case 1:
            collectionView.isUserInteractionEnabled = false
            guard let lastIndex = matchedPairs.last, let lastCell = collectionView.cellForItem(at: lastIndex) as? CardCell else {
                return
            }
            if randomLevelInfo[lastIndex.row] == getPair(cardValue) {
                matchedPairs.append(indexPath)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    cell.cardView.backgroundColor = .green
                    lastCell.cardView.backgroundColor = .green
                    collectionView.isUserInteractionEnabled = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    collectionView.reloadItems(at: [lastIndex, indexPath])
                    self?.matchedPairs.removeLast()
                    cell.cardLabel.isHidden = true
                    lastCell.cardLabel.isHidden = true
                    collectionView.isUserInteractionEnabled = true
                }
            }
            selectedItem = 0
        default:
            selectedItem = 0
        }
    }

    private func getPair(_ value: String) -> String {
        for tuple in currentLevelTuple {
            if tuple.0 == value {
                return tuple.1
            } else if tuple.1 == value {
                return tuple.0
            }
        }
        return ""
    }
}

