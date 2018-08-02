//
//  ViewController.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/8/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadCat()
    }
    
    func downloadCat() {
        self.activityIndicator.startAnimating()
        self.refreshButton.isEnabled = false
        
        let catURL = URL(string: "https://cataas.com/cat")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = NSData(contentsOf: catURL!)
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData! as Data)
                self.imageView.image = self.image
                self.activityIndicator.stopAnimating()
                self.refreshButton.isEnabled = true
            }
        }
    }

    @IBAction func didTapRefreshButton(_ sender: Any) {
        self.downloadCat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

