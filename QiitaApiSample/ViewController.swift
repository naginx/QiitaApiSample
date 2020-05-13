//
//  ViewController.swift
//  QiitaApiSample
//
//  Created by nagisa miura on 2020/05/02.
//  Copyright © 2020 nagisa miura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var titleArray: [String] = []
    var urlArray: [String] = []
    var alertController: UIAlertController!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        getQiitaTitle()
    }
    
    // MARK: - Logic
    
    func getQiitaTitle() {
        guard let baseUrl = URL(string: "https://qiita.com/api/v2/items?page=1&per_page=10&query="),
              let tags = URL(string: "tag%3AiOS+OR+tag%3ASwift+OR+tag%3AXcode"),
              let stocks = URL(string: "+stocks%3A%3E500"),
              let url = URL(string: "\(baseUrl)\(tags)\(stocks)")
              else { return }
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] else { return }
                let articles = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
                
                let count = articles.count
                for i in 0...count-1 {
                    guard let title = articles[i]["title"] as? String else { return }
                    guard let articleUrl = articles[i]["url"] as? String else { return }
                    self.titleArray.append(title)
                    self.urlArray.append(articleUrl)
                }
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            } catch {
                self.alert(title: "失敗", message: "エラー: \(error)")
            }
        })
        task.resume()
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: "\(urlArray[indexPath.row])") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

