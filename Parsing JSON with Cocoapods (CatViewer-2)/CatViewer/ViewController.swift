//
//  ViewController.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/8/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let catServiceURL = "https://cataas.com/cat"
let foxServiceURL = "https://randomfox.ca/floof"

class ViewController: UIViewController {

    @IBOutlet weak var foxRefreshButton: UIButton!
    @IBOutlet weak var catRefreshButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    var active: Bool = true {
        didSet{
            if active {
                self.activityIndicator.startAnimating()
                self.catRefreshButton.isEnabled = false
                self.foxRefreshButton.isEnabled = false
            }else{
                self.activityIndicator.stopAnimating()
                self.catRefreshButton.isEnabled = true
                self.foxRefreshButton.isEnabled = true
            }
        }
    }
    var foxService: FoxService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadFox()
    }
    
    func downloadFox() {
        self.active = true
        if self.foxService == nil{
            self.foxService = FoxService(serviceURL: foxServiceURL, completionHandler: { (image) in
                if let image = image {
                    self.image = image
                }
                self.active = false
            })
        }
        self.foxService?.download()
    }
    
    func downloadCat() {
        self.active = true
        let catURL = URL(string: catServiceURL)
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = NSData(contentsOf: catURL!)
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData! as Data)
                self.active = false
            }
        }
    }

    @IBAction func didTapFoxButton(_ sender: Any) {
        self.downloadFox()
    }
    
    @IBAction func didTapCatButton(_ sender: Any) {
        self.downloadCat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

