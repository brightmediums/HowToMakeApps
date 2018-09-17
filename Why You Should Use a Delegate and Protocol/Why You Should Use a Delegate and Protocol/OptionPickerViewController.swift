//
//  OptionPickerViewController.swift
//  Why You Should Use a Delegate and Protocol
//
//  Created by Joshua Stephenson on 9/13/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

protocol OptionPickerDelegate {
    func didSelectOption(option: String)
}

class OptionPickerViewController: UIViewController {

    var delegate: OptionPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapOptionA(_ sender: Any) {
        self.delegate?.didSelectOption(option: "A")
    }
    
    @IBAction func tapOptionB(_ sender: Any) {
        self.delegate?.didSelectOption(option: "B")
    }
   
}
