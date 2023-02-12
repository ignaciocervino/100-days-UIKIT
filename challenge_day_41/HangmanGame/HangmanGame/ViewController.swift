//
//  ViewController.swift
//  HangmanGame
//
//  Created by Ignacio Cervino on 10/02/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var attemptLabel: UILabel!
    @IBOutlet var txtField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var wordLabel: UILabel!

    var wordsArray = [String]()
    var usedLetters = [String]()
    var actualWord = ""
    var attempts = 0 {
        didSet {
            attemptLabel.text = "Remaining attempts: \(attempts)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpTopBar()
        startGame()
    }

    // UI functions
    private func setUpTopBar() {
        title = "Hangman"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshGame))
    }

    private func setUpUI() {
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }

    // Logic functions
    private func startGame() {
        usedLetters.removeAll()
        performSelector(inBackground: #selector(getWords), with: nil)
        wordLabel.text = ""
        txtField.text = ""
        DispatchQueue.main.async { [weak self] in
            guard let word = self?.wordsArray.first else { return }
            self?.wordLabel.text = self?.hideLetters(word)
            self?.actualWord = word
            self?.wordsArray.removeFirst()
            self?.attempts = word.count
        }
    }

    private func hideLetters(_ word: String) -> String {
        var result = ""
        for _ in 0..<word.count {
            result += "?"
        }
        return result
    }

    // Objc functions
    @objc private func refreshGame(action: UIAlertAction) {
        startGame()
    }

    @objc private func getWords() {
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                wordsArray = words.components(separatedBy: "\n")
            }
        }
        wordsArray.shuffle()
    }

    @objc private func submitAction() {
        guard let guess = txtField.text?.lowercased(), guess.count > 0, let word = wordLabel.text else { return }
        print("word:  \(actualWord) attempts: \(attempts)")
        if guess.count == 1 && checkLetter(guess) && !usedLetters.contains(guess) {
            attempts -= 1
            usedLetters.append(guess)
            updateWordLabel(alreadyWon: false)
        } else if guess.count > 1 && guess == actualWord {
            if guess == actualWord {
                updateWordLabel(alreadyWon: true)
                winAlert()
            } else {
                attempts -= 1
            }
        } else {
            attempts -= 1
        }

        if !word.contains("?") {
            updateWordLabel(alreadyWon: true)
            winAlert()
        } else if attempts <= 0 {
            lostAlert()
        }

        txtField.text = ""
    }

    private func checkLetter(_ word: String) -> Bool {
        return actualWord.contains(word)
    }

    private func winAlert() {
        let ac = UIAlertController(title: "You won!!", message: "Congratulations, thats the correct word", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: refreshGame))
        present(ac, animated: true)
    }

    private func lostAlert() {
        let ac = UIAlertController(title: "You lost :(", message: "The correct word was \(actualWord)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: refreshGame))
        present(ac, animated: true)
    }

    private func updateWordLabel(alreadyWon: Bool) {
        var updatedWord = ""
        if !alreadyWon {
            for letter in actualWord {
                if !usedLetters.contains(String(letter)) {
                    updatedWord += "?"
                } else {
                    updatedWord += String(letter)
                }
            }
            wordLabel.text = updatedWord.uppercased()
        } else {
            wordLabel.text = actualWord.uppercased()
        }
    }

}

