//
//  ViewController.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/8/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let serviceURL = "https://randomfox.ca/floof"

class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet{
            if image != nil{
                self.imageView.image = image
            }
        }
    }
    var catService: CatService?
    var active: Bool = true {
        didSet{
            if active {
                self.activityIndicator.startAnimating()
                self.refreshButton.isEnabled = false
            }else{
                self.activityIndicator.stopAnimating()
                self.refreshButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadCat()
    }
    
    func downloadCat() {
        if self.catService == nil, let url = URL(string: serviceURL) {
            self.catService = CatService(serviceURL: url, completionBlock: { (image) in
                if let image = image {
                    self.image = image
                }
                self.active = false
            })
        }
        self.active = true
        self.catService!.downloadCat()
    }
    
    func gotCat(){
        
    }

    @IBAction func didTapRefreshButton(_ sender: Any) {
        self.downloadCat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

