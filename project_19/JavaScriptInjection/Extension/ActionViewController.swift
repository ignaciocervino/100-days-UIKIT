//
//  ActionViewController.swift
//  Extension
//
//  Created by Ignacio Cervino on 24/02/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var script: UITextView!

    var pageTitle = ""
    var pageURL = ""

    let defaults: UserDefaultsManaging = UserDefaultsManager()
    var defaultScriptName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addScript))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }

                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    // Update view on thread
                    DispatchQueue.main.async {
                        guard let self = self else { return }

                        self.title = self.pageTitle
                        self.script.text = self.defaults.retrieveScript(with: self.defaultScriptName)
                    }
                }
            }
        }
    }

    @IBAction func done() {
        askUserScriptName()
    }

    private func scriptAction() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }

    private func askUserScriptName() {
        let ac = UIAlertController(title: "Name your script", message: "Write a name for your script", preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac, weak self] _ in
            let answer = ac.textFields![0]
            if let answerText = answer.text {
                if !answerText.isEmpty, answerText != "Empty" {
                    self?.scriptAction()
                    self?.defaults.saveJsToUserDefaults(with: answerText, using: self?.script.text)
                } else {
                    let ac = UIAlertController(title: "That name is not possible", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self?.present(ac, animated: true)
                }
            }
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    @objc func addScript() {
        let ac = UIAlertController(title: "Choose an script", message: "These are prewritten scripts", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Alert", style: .default) { [weak self] _ in
            self?.script.text.append(contentsOf: "alert(document.title);\n")
        })
        ac.addAction(UIAlertAction(title: "Blur", style: .default) { [weak self] _ in
            self?.script.text.append(contentsOf: "window.blur();\n")
        })
        ac.addAction(UIAlertAction(title: "Open Google", style: .default) { [weak self] _ in
            self?.script.text.append(contentsOf: "window.open('https://www.google.com');\n")
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        // Scroll indicator insets control how big the scroll bars are relative to their view.
        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
