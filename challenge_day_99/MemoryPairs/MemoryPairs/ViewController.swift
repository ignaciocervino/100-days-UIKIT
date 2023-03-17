//
//  ViewController.swift
//  MemoryPairs
//
//  Created by Ignacio Cervino on 09/03/2023.
//

import UIKit

typealias CountriesInfo = [String: String]

class ViewController: UICollectionViewController {
    var countriesInfoTuple: [(String, String)] = [] // store all the data
    var currentLevelTuple: [(String, String)] = []
    var randomLevelInfo: [String] = [] // current level countries/codes
    var gameRows = [2,2,2,2,4,4,4,4,4,4,6,6,6,6,6]
    var gameRowsIndex = 0

    var matchedPairs: [IndexPath] = [] // Define the matchedPairs array
    var shouldMatchValue: String = ""

    var selectedItem: Int = 0

    var gameOver: Bool = false
    var gameScore: Int = 0
    var levelMatchScore = 0 {
        didSet {
            checkEndLevel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        loadCountriesInfoFromFile(named: "CountriesInfo") { [weak self] result in
            switch result {
            case .success(let decodedDictionary):
                self?.countriesInfoTuple = decodedDictionary.map { ($0, $1) }
                self?.setupGameArray()
                self?.collectionView.reloadData()

            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }

    }

    private func checkEndLevel() {
        if gameRowsIndex == gameRows.count - 1 {
            gameOver = true
        }
        
        let ac = UIAlertController(title: "You won level \(gameRowsIndex + 1) !!", message: "Lets go to the next one", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Next level", style: .default) { _ in
            if !self.gameOver {
                // Increase the number of rows
                self.gameRowsIndex += 1
                self.playNextLevel()
            } else {
                self.resetGame()
            }
        })
        if levelMatchScore == currentLevelTuple.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.present(ac, animated: true)
            }
        }
    }
    
    private func resetGame() {
        let ac = UIAlertController(title: "Congratulations!", message: "You won the game!! Wohooo", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Play again", style: .default) { _ in
            self.resetBoard()
        })
        
        if gameOver {
            present(ac, animated: true)
        } else {
            // reload button
            resetBoard()
        }
    }
    
    private func resetBoard() {
        gameOver = false
        gameScore = 0
        gameRowsIndex = 0
        playNextLevel()
    }

    private func playNextLevel() {
        // Delete the matched pairs
        collectionView.deleteItems(at: matchedPairs)

        // Reset variables
        levelMatchScore = 0
        selectedItem = 0
        randomLevelInfo.removeAll()
        currentLevelTuple.removeAll()
        matchedPairs.removeAll()
        shouldMatchValue = ""

        // Generate a new game array
        setupGameArray()

        // Update the collection view layout
        setupCollectionViewLayout()

        // Reload the collection view data
        UIView.transition(with: collectionView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }

    private func setupGameArray() {
        countriesInfoTuple.shuffle()
        currentLevelTuple = Array(countriesInfoTuple.prefix((gameRows[gameRowsIndex] * gameRows[gameRowsIndex]) / 2))

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
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let collectionViewLayout = CollectionViewLayout()
        collectionViewLayout.numberOfItemsPerRow = CGFloat(gameRows[gameRowsIndex])
//        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
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
        return gameRows[gameRowsIndex] * gameRows[gameRowsIndex]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }

        guard !randomLevelInfo.isEmpty, indexPath.row < randomLevelInfo.count else { return cell}

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
                    self.levelMatchScore += 1
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
