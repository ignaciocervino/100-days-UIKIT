//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ignacio Cervino on 30/01/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 0
    var total = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor // cgColor returns the color to the apple color graphics
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }

    func askQuestion(_ action: UIAlertAction? = nil) {
        let finalAlert = UIAlertController(title: "Final result", message: "Your final score is \(score)/\(total)", preferredStyle: .alert)

        title = countries[correctAnswer].uppercased() + " Score: \(score)/\(total)"

        if numberOfQuestions == total {
            finalAlert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
            present(finalAlert, animated: true)
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)

            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)

            title = countries[correctAnswer].uppercased() + " Score: \(score)/\(total)"
        }
    }

    func resetGame(_ action: UIAlertAction? = nil) {
        numberOfQuestions = 0
        score = 0
        askQuestion()
    }

    // IB action function for buttons, we cant identify them using tag property
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that's \(countries[sender.tag].uppercased()) flag"
            score -= 1
        }
        numberOfQuestions += 1

        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)

        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))

        present(ac, animated: true)
    }

}

