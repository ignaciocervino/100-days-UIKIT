//
//  WikipediaViewController.swift
//  CapitalCities
//
//  Created by Ignacio Cervino on 22/02/2023.
//

import UIKit
import WebKit

class WikipediaViewController: UIViewController {

    var webView: WKWebView!
    var capital: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let capital = capital, let url = URL(string: "https://en.wikipedia.org/wiki/\(capital)") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
