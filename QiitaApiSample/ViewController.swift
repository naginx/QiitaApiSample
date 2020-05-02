//
//  ViewController.swift
//  QiitaApiSample
//
//  Created by nagisa miura on 2020/05/02.
//  Copyright © 2020 nagisa miura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var titleArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        getQiitaTitle()
    }
    
    func getQiitaTitle() {
        let url: URL = URL(string: "https://qiita.com/api/v2/items?page=1&query=user%3Anaginx")!
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]
                let articles = json.map { (article) -> [String: Any] in
                    return article as! [String: Any]
                }
                
                let count = articles.count
                for i in 0...count-1 {
                    let title = articles[i]["title"] as! String
                    self.titleArray.append(title)
                }
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        })
        
        task.resume()
    }
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
}

