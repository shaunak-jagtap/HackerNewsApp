//
//  ViewController.swift
//  NewsApp
//
//  Created by Shaunak Jagtap on 14/09/20.
//  Copyright © 2020 logicPlay. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!

    var newsArray = [News]()
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        //Setup tableView
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsTableViewCell")
        self.tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NoDataTableViewCell")
        self.tableView.tableFooterView = UIView()

        //setup loading indicator
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.view.bounds.width/2 - 30), y: (self.view.bounds.height/2 - 30), width: 30, height: 30))
        self.activityIndicator?.center = self.view.center
        self.activityIndicator?.color = .black
        self.view.addSubview(self.activityIndicator ?? UIView())

        //setup SearchBar
        self.searchBar.delegate = self
    }

    private func searchNews(query: String) {
        self.activityIndicator?.startAnimating()
        weak var weakSelf = self
        NewsController.shared.searchNews(query: query, success: { news in
            if news.count > 0 {
                weakSelf?.newsArray = news
            } else {
                weakSelf?.newsArray.removeAll()
            }

            DispatchQueue.main.async {
                weakSelf?.activityIndicator?.stopAnimating()
                weakSelf?.tableView.reloadData()
            }

        }, failure: { error in
            print(error.localizedDescription)
            DispatchQueue.main.async {
                weakSelf?.activityIndicator?.stopAnimating()
            }
        })

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsArray.count == 0 {
            return 1
        } else {
            return newsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if newsArray.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell {
                tableView.separatorColor = .clear
                return cell
            }
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            if newsArray.count > indexPath.row {
                tableView.separatorColor = .lightGray
                cell.newsTitleLabel.text = newsArray[indexPath.row].title
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newsArray.count > indexPath.row {
            self.activityIndicator?.stopAnimating()
            let news = newsArray[indexPath.row]
            webView.navigationDelegate = self

            if let url = URL(string: news.url) {
                self.activityIndicator?.startAnimating()
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator?.stopAnimating()
        self.webView.isHidden = true
        self.tableView.isHidden = false
        self.searchNews(query: searchText)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator?.stopAnimating()
        self.tableView.isHidden = true
        self.webView.isHidden = false
    }
}

