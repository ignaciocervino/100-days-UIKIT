//
//  ViewController.swift
//  WebViewApp
//
//  Created by Ignacio Cervino on 01/02/2023.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView! // How much of the page was loaded
    var website = ""

    override func loadView() { // Gets call before view did load
        webView = WKWebView()
        webView.navigationDelegate = self
//        webView.translatesAutoresizingMaskIntoConstraints = false
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit() // Take as much space as it needs
        let progressButton = UIBarButtonItem(customView: progressView) // So it can go inside our toolbar

        toolbarItems = [back, spacer, goForward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        let url = URL(string: "https://" + website)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true // Let you go forward o backward in the webview with gestures
    }

    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)

        ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))


        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem // Tells iOS when it should attach this in iPad
        present(ac, animated: true)
    }

    private func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)! // We know it will be safe
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // When finish loading it page
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Evaluate the URl to see if is in our safe list
        let url = navigationAction.request.url
        let alert = UIAlertController(title: "Warning", message: "This page is not allowed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        if let host = url?.host {
            if host.contains(website) {
                decisionHandler(.allow)
                return
            }
            // Show an alert for not allowed host
            present(alert,animated: true)
        }

        decisionHandler(.cancel)
    }
}

