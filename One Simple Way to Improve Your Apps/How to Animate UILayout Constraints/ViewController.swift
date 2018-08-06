//
//  ViewController.swift
//  How to Animate UILayout Constraints
//
//  Created by Joshua Stephenson on 8/5/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let animationDuration = 1.0
let springDamping = CGFloat(0.5)
let initialVelocity = CGFloat(0.2)

class ViewController: UIViewController {

    @IBOutlet weak var ballPink: UIButton!
    @IBOutlet weak var ballYellow: UIButton!
    @IBOutlet weak var ballBlue: UIButton!
    @IBOutlet weak var ballPinkTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var ballYellowTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var ballBlueTopSpaceConstraint: NSLayoutConstraint!
    
    var ballLookup: [UIButton:(constraint:NSLayoutConstraint, function: UIViewAnimationOptions)]!
    var topConstant:CGFloat!
    var bottomConstant:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ballLookup = [
            ballPink:(constraint: ballPinkTopSpaceConstraint, function:.curveEaseIn),
            ballYellow:(constraint: ballYellowTopSpaceConstraint, function:.curveEaseOut),
            ballBlue:(constraint: ballBlueTopSpaceConstraint, function:.curveEaseInOut)
        ]
        
        ballPink.layer.cornerRadius = ballPink.frame.size.width / 2.0
        ballBlue.layer.cornerRadius = ballBlue.frame.size.width / 2.0
        ballYellow.layer.cornerRadius = ballYellow.frame.size.width / 2.0
        self.topConstant = ballPinkTopSpaceConstraint.constant
        self.bottomConstant = self.view.frame.size.height - ballPink.frame.size.height * 2.0 - self.topConstant
    }
    
    @IBAction func ballTap(_ sender: Any) {
        let button              = sender as! UIButton
        let info                = self.ballLookup[button]
        let constraint          = info!.constraint
        let easingFunction      = info!.function
        let newConstant = constraint.constant == topConstant ? bottomConstant : topConstant
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: initialVelocity, options: easingFunction, animations: {
            constraint.constant = newConstant!
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

