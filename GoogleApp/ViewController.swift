//
//  ViewController.swift
//  GoogleApp
//
//  Created by MacOS on 15/12/2017.
//  Copyright © 2017 amberApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultTitles = [String]()
    
    @IBAction func searchInGoogle(_ sender: UIButton) {
        resultTitles.removeAll()
        sendRequest()
    }
    
    @IBAction func showResults(_ sender: UIButton) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func sendRequest() {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let searchWords = textField.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: "https://www.googleapis.com/customsearch/v1?key=AIzaSyCRx1TzMXvZmNn7hllGx_VPMFHFp7vvVD8&cx=015479572664441330661:fcm_kei-4um&q=" + searchWords!) else {
                return
            }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print(error as Any)
            }
            guard let data = data else {
                return
            }
            guard let json = try?
                JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                return
            }
            
            guard let results = json as? Dictionary<String, Any>, let items = results["items"] as? Array<Dictionary<String, Any>> else {
                return
            }
            for item in items {
                let htmlTitle = item["title"] as? String
                self?.resultTitles.append(htmlTitle!)
            }
            print(self?.resultTitles ?? "Title")
        })
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        tableViewCell.textLabel?.numberOfLines = 2
        let titles = resultTitles[indexPath.row]
        tableViewCell.textLabel?.text = titles
        return tableViewCell
    }
}

