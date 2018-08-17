//
//  ViewController.swift
//  Instagram Like Stickers
//
//  Created by Joshua Stephenson on 8/17/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let maximumScale = CGFloat(1.1)
let minimumScale = CGFloat(0.9)

class Sticker : UIImageView {
    var constraintLeft: NSLayoutConstraint!
    var constraintTop: NSLayoutConstraint!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stickerTaco: Sticker!
    @IBOutlet weak var stickerFlower: Sticker!
    @IBOutlet weak var stickerMonkey: Sticker!
    
    @IBOutlet weak var constraintTacoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerTop: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyLeft: NSLayoutConstraint!
    
    var twoFingersActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stickerTaco.constraintLeft     = self.constraintTacoLeft
        self.stickerTaco.constraintTop      = self.constraintTacoTop
        self.stickerFlower.constraintLeft   = self.constraintFlowerLeft
        self.stickerFlower.constraintTop    = self.constraintFlowerTop
        self.stickerMonkey.constraintLeft   = self.constraintMonkeyLeft
        self.stickerMonkey.constraintTop    = self.constraintMonkeyTop
    }
    
    // Used to track how much translation has already been accounted for while finger remains down
    var adjustedTranslation = CGPoint(x: 0.0, y: 0.0)
    
    @IBAction func didDragSticker(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        var translation = recognizer.translation(in: self.view)
        let sticker = recognizer.view as! Sticker
        
        if recognizer.state == .began {
            self.view.bringSubview(toFront: sticker)
        }else if recognizer.state == .changed {
            // adjust the translation by the amount already moved
            translation.x -= adjustedTranslation.x
            translation.y -= adjustedTranslation.y
            
            // move the sticker by the remaining amount
            sticker.constraintLeft.constant = sticker.constraintLeft.constant + translation.x
            sticker.constraintTop.constant = sticker.constraintTop.constant + translation.y
            
            // ammend translation to account for total adjustment
            adjustedTranslation.x += translation.x
            adjustedTranslation.y += translation.y
        }else if recognizer.state == .ended {
            adjustedTranslation = CGPoint(x: 0.0, y: 0.0)
        }
        
    }
}

