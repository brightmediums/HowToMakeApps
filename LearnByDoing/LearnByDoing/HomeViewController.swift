//
//  ViewController.swift
//  LearnByDoing
//
//  Created by Joshua Stephenson on 5/10/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var isDark: Bool = false
    @IBOutlet weak var mainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTap(_ sender: Any) {
        if(self.isDark) {
            self.view.backgroundColor = UIColor.white
            self.isDark = false
            self.mainButton.setTitle("Matte Black Everything", for: UIControlState.normal)
        }else{ // light
            self.view.backgroundColor = UIColor.black
            self.isDark = true
            self.mainButton.setTitle("Matte Black Everything", for: UIControlState.normal)
        }
    }
    
}

