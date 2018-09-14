//
//  OptionPickerViewController.swift
//  Why You Should Use a Delegate and Protocol
//
//  Created by Joshua Stephenson on 9/13/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class OptionPickerViewController: UIViewController {

    var firstViewController: FirstViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapOptionA(_ sender: Any) {
        self.firstViewController?.selectedOption(option: "A")
    }
    
    @IBAction func tapOptionB(_ sender: Any) {
        self.firstViewController?.selectedOption(option: "B")
    }
   
}
