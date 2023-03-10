//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Ignacio Cervino on 26/02/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal(at:)))

    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }

    @objc func scheduleLocal(at time: Double = 0) {
        let timeInterval = time > 0 ? time : 5

        registerCategories() // So iOS knows immediately what alarm means
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Content to show in the notification
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm" // Type of alert
        content.userInfo = ["customData": "fizzbuzz"] // link notification to app content
        content.sound = .default

        // When to show it
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        // create for an specific date and hour
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        // Create the request and add it to the notification center
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        // foreground means when this notification is touch, go to the app immediately
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: .foreground)

        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindLater], intentIdentifiers: [], options: [])

        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        var alertTitle = ""

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                alertTitle = "Default identifier"
            case "show":
                alertTitle = "Show more information.."
            case "remindLater":
                alertTitle = "Will remind you again in 24 hours"
                scheduleLocal(at: 5)
            default:
                break
            }
        }

        let ac = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac,animated: true)

        completionHandler()
    }
}

