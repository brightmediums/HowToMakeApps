//
//  FirstViewController.swift
//  Why You Should Use a Delegate and Protocol
//
//  Created by Joshua Stephenson on 9/13/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func selectOptions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionPicker") as! OptionPickerViewController
        vc.firstViewController = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func selectedOption(option: String){
        self.dismiss(animated: true, completion: nil)
        print("User selected option \(option)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

