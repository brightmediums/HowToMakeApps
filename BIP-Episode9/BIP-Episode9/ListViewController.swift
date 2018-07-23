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
import SVProgressHUD

let urlString = "http://universities.hipolabs.com/search?name=technology"

class ListViewController: UITableViewController {

    var reachability: Reachability!
    var universities: [JSON]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reachability = Reachability()
        
        if reachability.connection == .none {
            loadFromLocal()
        }else{
            loadFromRemote()
        }
    }
    
    private func loadFromRemote(){
        SVProgressHUD.show(withStatus: "Loading from remote server")
        Alamofire.request(urlString).responseData { (data) in
            if let jsonString = data.result.value {
                let json = JSON(jsonString).arrayValue
                self.displayJSON(json: json)
            }
        }
    }
    
    private func loadFromLocal() {
        SVProgressHUD.show(withStatus: "Loading from local cache")
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = JSON(data).arrayValue
                self.displayJSON(json: json)
            } catch{
                print("Error loading data from cache. Handle this in some smart way.")
            }
        }else {
            print("Could not find cached data file")
        }
    }
    
    private func displayJSON(json: [JSON]) {
        self.universities = json
        tableView.reloadData()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0, execute: {
            SVProgressHUD.dismiss()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities == nil ? 0 : universities!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let universityJSON = universities![indexPath.row]
        cell.textLabel?.text = universityJSON["name"].stringValue

        return cell
    }
    
}
