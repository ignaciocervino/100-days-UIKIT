//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ignacio Cervino on 30/01/2023.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 0
    var total = 10
    var highScore = 0
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Local notifications
        registerLocalNotification()

        highScore = defaults.integer(forKey: "Highscore")

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        view.backgroundColor = .lightGray

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
        finalAlert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
        let highScoreAlert = UIAlertController(title: "Congratulations!", message: "You have the highest score", preferredStyle: .alert)
        highScoreAlert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.present(finalAlert, animated: true)
        })

        title = countries[correctAnswer].uppercased() + " Score: \(score)/\(total)"

        if numberOfQuestions == total {
            if score > highScore {
                defaults.set(score, forKey: "HighScore")
                present(highScoreAlert, animated: true)
            } else {
                present(finalAlert, animated: true)
            }
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
        let buttonPosition = sender.frame.origin
        // Animation
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }) { finished in
            UIView.animate(withDuration: 1) {
                sender.transform = .identity
            }
        }

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

    // Local notifications
    func registerLocalNotification() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
                self.scheduleLocalNotification()
            } else {
                print("D'oh")
            }
        }
    }

    func scheduleLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        // Content to show in the notification
        let content = UNMutableNotificationContent()
        content.title = "Come back and play!"
        content.body = "This is a reminder to play this amazing game!"
        content.categoryIdentifier = "alarm" // Type of alert
        content.userInfo = ["customData": "fizzbuzz"] // link notification to app content
        content.sound = .default

        let play = UNNotificationAction(identifier: "play", title: "Play now", options: .foreground)
        let category = UNNotificationCategory(identifier: "comeBack", actions: [play], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])

        // When to show it
        var dateComponents = DateComponents()
        dateComponents.hour = 24
        // create for an specific date and hour
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // Create the request and add it to the notification center
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
        }

        completionHandler()
    }

}

