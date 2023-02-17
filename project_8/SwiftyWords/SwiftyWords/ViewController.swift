//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Ignacio Cervino on 08/02/2023.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()

    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0 {
        // Update score label every time is changed
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)

        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)

        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24) // Whatever font is default today
        answerLabel.numberOfLines = 0
        answerLabel.text = "ANSWER"
        answerLabel.textAlignment = .right
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)

        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)

        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)

        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),

            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),

            buttonView.widthAnchor.constraint(equalToConstant: 750),
            buttonView.heightAnchor.constraint(equalToConstant: 320),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

        let width = 150
        let height = 80

        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }

        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender) // So we know it was tapped
        UIView.animate(withDuration: 0.5, animations: {
            sender.alpha = 0.1
        }) { finished in
            sender.isHidden = true
        }
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswer = answerLabel.text?.components(separatedBy: "\n")
            splitAnswer?[solutionPosition] = answerText
            answerLabel.text = splitAnswer?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            if letterButtons.first(where: { $0.isHidden == false }) == nil {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong guess!", message: "Be careful you will lose points", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reducePoints))
            present(ac, animated: true)
        }
    }

    func reducePoints(action: UIAlertAction) {
        if score > 0 {
            score -= 1
        }
    }

    func levelUp(action: UIAlertAction) {
        level += 1

        solutions.removeAll(keepingCapacity: true)
        loadLevel()

        for button in letterButtons {
            button.isHidden = false
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for button in activatedButtons {
            button.isHidden = false
            button.alpha = 1
        }

        activatedButtons.removeAll()
    }

    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let levelFileURL = Bundle.main.url(forResource: "level\(self?.level ?? 1)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileURL) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()

                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]

                        clueString += "\(index + 1). \(clue)\n"

                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        self?.solutions.append(solutionWord)

                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }

                    DispatchQueue.main.async {
                        self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                        self?.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

                        self?.letterButtons.shuffle()

                        if self?.letterButtons.count == letterBits.count {
                            for i in 0..<letterBits.count {
                                self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
}

