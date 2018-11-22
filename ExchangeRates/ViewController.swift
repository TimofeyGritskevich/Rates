//
//  ViewController.swift
//  ExchangeRates
//
//  Created by Tima on 20.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateTimeLabel: UILabel!

    var ratesArray = Manager.result.sorted(byKeyPath: "order")
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        if ratesArray.count == 0 {
            updateRates()
        }
        updateTimeLabel.text = Manager.loadDate()
    }
    
    func updateRates() {
        if !Connectivity.isConnectedToInternet() {
            setConnectionProblemsAlert()
        } else {
            fetchData()
        }
    }
    
    func fetchData() {
        setActivityIndicator()
        let feedParser = FeedParser()
        feedParser.parseFeed(url: Manager.urlString) { (curArray, error) in
            if let error = error {
                self.setErrorAlert(error: error)
            } else {
                DispatchQueue.main.async {
                    if let curArray = curArray {
                        if self.ratesArray.count == 0 {
                            Manager.saveRealm(rates: curArray)
                        } else {
                            Manager.updateRates(rates: curArray)
                        }
                    }
                    self.tableView.reloadData()
                    self.updateTimeLabel.text = Manager.setTime()
                    self.removeActivityIndicator()
                }
            }
        }
    }

    func setActivityIndicator() {
        activityIndicator.frame = CGRect(x: (view.frame.width - 100)/2, y: (view.frame.height - 100)/2, width: 100, height: 100)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    @IBAction func refreshRatesButtonPressed(_ sender: UIButton) {
        updateRates()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Edit" {
            tableView.isEditing = true
            sender.setTitle("Done", for: .normal)
        } else {
            tableView.isEditing = false
            sender.setTitle("Edit", for: .normal)
        }    
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ratesArray.count != 0 {
            return ratesArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RateTableViewCell", for: indexPath) as? RateTableViewCell else {
            return RateTableViewCell()
        }
        let item = ratesArray[indexPath.row]
        cell.currency = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! Manager.realm.write {
            let sourceObject = ratesArray[sourceIndexPath.row]
            let destinationObject = ratesArray[destinationIndexPath.row]
            let destinationObjectOrder = destinationObject.order
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = ratesArray[index]
                    object.order -= 1
                }
            } else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = ratesArray[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
        }
    }
}
