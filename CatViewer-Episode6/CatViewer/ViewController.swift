//
//  ViewController.swift
//  CatViewer
//
//  Created by Joshua Stephenson on 6/8/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var foxButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    var active: Bool = true {
        didSet {
            if active {
                self.activityIndicator.startAnimating()
                self.catButton.isEnabled = false
                self.foxButton.isEnabled = false
            }else {
                self.activityIndicator.stopAnimating()
                self.catButton.isEnabled = true
                self.foxButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadCat()
    }
    
    func downloadCat() {
        self.active = true
        let catURL = URL(string: "https://cataas.com/cat")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = NSData(contentsOf: catURL!)
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData! as Data)
                self.active = false
            }
        }
    }
    
    func downloadFox() {
        
    }

    @IBAction func didTapCatButton(_ sender: Any) {
        self.downloadCat()
    }
    
    @IBAction func didTapFoxButton(_ sender: Any) {
        self.downloadFox()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

