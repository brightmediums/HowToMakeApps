//
//  TextEntryViewController.swift
//  Stickers Like Instagram Stories
//
//  Created by Joshua Stephenson on 10/1/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

protocol TextEntryDelegate {
    func didAdd(text: String)
}

class TextEntryViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var delegate: TextEntryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
    }

    @IBAction func didSelectDone(_ sender: Any) {
        self.delegate?.didAdd(text: textField.text!)
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
