//
//  SignupStep2ViewController.swift
//  Icarus
//
//  Created by Joshua Stephenson on 6/3/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class SignupStep2ViewController: UIViewController {

    @IBOutlet weak var emailFieldLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailFieldLabel.text = "Hi \(user!.name!). What's your email?"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
