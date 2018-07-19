//
//  ViewController.swift
//  BIP-Episode8
//
//  Created by Joshua Stephenson on 7/18/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didTapButton(_ sender: Any) {
        tapFeedback()
    }
    
    @IBAction func didTapFakeButtonWithRecognizer(_ sender: Any) {
        tapFeedback()
    }
    
    private func tapFeedback() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.green
        }) { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.view.backgroundColor = UIColor.white
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

