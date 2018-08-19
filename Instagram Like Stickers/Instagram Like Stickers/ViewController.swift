//
//  ViewController.swift
//  Instagram Like Stickers
//
//  Created by Joshua Stephenson on 8/17/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class Sticker: UIImageView {
    var constraintTop: NSLayoutConstraint!
    var constraintLeft: NSLayoutConstraint!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stickerMonkey: Sticker!
    @IBOutlet weak var stickerTaco: Sticker!
    @IBOutlet weak var stickerFlower: Sticker!
    
    @IBOutlet weak var constraintMonkeyLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stickerMonkey.constraintLeft = constraintMonkeyLeft
        self.stickerMonkey.constraintTop = constraintMonkeyTop
        
        self.stickerFlower.constraintLeft = constraintFlowerLeft
        self.stickerFlower.constraintTop = constraintFlowerTop
        
        self.stickerTaco.constraintLeft = constraintTacoLeft
        self.stickerTaco.constraintTop = constraintTacoTop
    }
    
    // Used to track how much translation has already been accounted for while the finger remains down
    var adjustedTranslation = CGPoint(x: 0.0, y: 0.0)
    
    @IBAction func didPanSticker(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        
        if let sticker = recognizer.view as? Sticker {
            var translation = recognizer.translation(in: self.view)
            
            if recognizer.state == .began {
                self.view.bringSubview(toFront: sticker)
            }else if recognizer.state == .changed {
                translation.y -= adjustedTranslation.y
                translation.x -= adjustedTranslation.x
                
                sticker.constraintTop.constant += translation.y
                sticker.constraintLeft.constant += translation.x
                
                adjustedTranslation.y += translation.y
                adjustedTranslation.x += translation.x
            }else if recognizer.state == .ended {
                adjustedTranslation = CGPoint(x: 0.0, y: 0.0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
