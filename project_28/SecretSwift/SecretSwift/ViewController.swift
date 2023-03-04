//
//  ViewController.swift
//  SecretSwift
//
//  Created by Ignacio Cervino on 04/03/2023.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secret: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nothing to see here"

        let lock = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(lockApp))
        navigationItem.rightBarButtonItem = lock
        navigationItem.rightBarButtonItem?.isHidden = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc private func lockApp() {
        saveSecretMessage()
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                // so not to block the main thread, UI goes on main
                DispatchQueue.main.async {
                    if success {
                        self?.navigationItem.rightBarButtonItem?.isHidden = false
                        self?.unlockSecretMessage()
                    } else {
                        // error
                        let ac = UIAlertController(title: "AuthenticationFailed", message: "Your could not be verified, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "Secret Message") ?? ""
    }

    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem?.isHidden = true
    }
}

