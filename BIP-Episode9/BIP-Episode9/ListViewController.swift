//
//  ListViewController.swift
//  BIP-Episode9
//
//  Created by Joshua Stephenson on 7/23/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Reachability

let urlString = "http://universities.hipolabs.com/search?name=technology"

enum ActivityState {
    case inactive
    case loadingLocal
    case loadingRemote
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var reachability: Reachability!
    var countries: [String]?
    
    @IBOutlet weak var tableViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    var state: ActivityState = .inactive {
        didSet {
            switch state {
            case .inactive:
                self.activityIndicator.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.activityLabel.text = ""
                    UIView.animate(withDuration: 0.50) {
                        self.tableViewTopSpaceConstraint.constant = 0.0
                        self.view.layoutIfNeeded()
                    }
                }
            default:
                self.activityIndicator.startAnimating()
                self.activityLabel.text = state == .loadingLocal ? "Loading data from cache" : "Downloading data from server"
                UIView.animate(withDuration: 0.50) {
                    self.tableViewTopSpaceConstraint.constant = 60.0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability()
        
        loadData()
        
        // Anytime the app is brought to the foreground, load data accordingly
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: - Private
    let cacheFileName = "BIP-Episode9-countries-data"
    
    @objc private func loadData() {
        loadFromLocalCache() // no matter what, always load what's cached
        if self.reachability.connection != .none {
            // then if we have a connection, update the cache from the remote server
            // We added a 2 second delay here because loading from cache happens so quickly
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadFromRemoteServer()
            }
        }
    }
    
    private func loadFromRemoteServer(){
        self.state = .loadingRemote
        Alamofire.request(urlString).responseData { (data) in
            if let jsonString = data.result.value {
                let json = JSON(jsonString).arrayValue
                self.displayJSON(json: json)
                self.cacheData(data: data.data!)
            }
            self.state = .inactive
        }
    }
    
    private func loadFromLocalCache() {
        self.state = .loadingLocal
        do {
            let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = cacheDir.appendingPathComponent(cacheFileName)
            
            let data = try Data(contentsOf: fileURL)
            let json = JSON(data).arrayValue
            self.displayJSON(json: json)
        }catch{
            print(error)
        }
    }
    
    private func cacheData(data: Data) {
        do {
            let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor:nil, create:true)
            let fileURL = cacheDir.appendingPathComponent(cacheFileName)
            try data.write(to: fileURL)
            print("Saved \(data.count) to cache")
        } catch {
            print(error)
        }
    }
    
    private func displayJSON(json: [JSON]) {
        self.countries = []
        json.forEach { (school) in
            let country = school["country"].stringValue
            if let countries = self.countries, !countries.contains(country) {
                self.countries!.append(country)
            }
        }
        self.countries = self.countries!.sorted()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries == nil ? 0 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let countries = self.countries {
            cell.textLabel?.text = countries[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
