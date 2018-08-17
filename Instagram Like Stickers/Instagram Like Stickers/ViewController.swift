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
    var constraintHeight: NSLayoutConstraint!
    var originBeforeDragging: CGPoint!
    var workingHeight: CGFloat!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stickerTaco: Sticker!
    @IBOutlet weak var stickerFlower: Sticker!
    @IBOutlet weak var stickerMonkey: Sticker!
    
    @IBOutlet weak var constraintTacoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerTop: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyTop: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stickerTaco.constraintLeft     = self.constraintTacoLeft
        self.stickerTaco.constraintTop      = self.constraintTacoTop
        self.stickerFlower.constraintLeft    = self.constraintFlowerLeft
        self.stickerFlower.constraintTop     = self.constraintFlowerTop
        self.stickerMonkey.constraintLeft    = self.constraintMonkeyLeft
        self.stickerMonkey.constraintTop     = self.constraintMonkeyTop
        self.stickerTaco.constraintHeight   = self.constraintTacoHeight
        self.stickerFlower.constraintHeight  = self.constraintFlowerHeight
        self.stickerMonkey.constraintHeight  = self.constraintMonkeyHeight
        
        self.stickerTaco.originBeforeDragging = CGPoint(x: self.stickerTaco.constraintLeft.constant, y: self.stickerTaco.constraintTop.constant)
        
        self.stickerFlower.originBeforeDragging = CGPoint(x: self.stickerFlower.constraintLeft.constant, y: self.stickerFlower.constraintTop.constant)
        
        self.stickerMonkey.originBeforeDragging = CGPoint(x: self.stickerMonkey.constraintLeft.constant, y: self.stickerMonkey.constraintTop.constant)
    }
    
    @IBAction func didPinchSticker(_ sender: Any) {
        let recognizer = sender as! UIPinchGestureRecognizer
        let sticker = recognizer.view as! Sticker
        
        if recognizer.state == .began {
            sticker.workingHeight = sticker.constraintHeight.constant
        }else if recognizer.state == .changed {
            let scale = recognizer.scale //> 1.0 ? maximumScale : minimumScale
            let newHeight = sticker.workingHeight * scale
            print("scale \(scale), height \(sticker.workingHeight), newHeight \(newHeight)")
            sticker.constraintHeight.constant = newHeight
        }
    }
    
    @IBAction func didDragSticker(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        let translation = recognizer.translation(in: self.view)
        let sticker = recognizer.view as! Sticker
        
        
        if recognizer.state == .began {
            self.view.bringSubview(toFront: sticker)
        }else if recognizer.state == .changed {
            sticker.constraintLeft.constant = translation.x + sticker.originBeforeDragging.x
            sticker.constraintTop.constant = translation.y + sticker.originBeforeDragging.y
        }else if recognizer.state == .ended {
            sticker.originBeforeDragging = CGPoint(x: sticker.constraintLeft.constant, y: sticker.constraintTop.constant)
        }
        
    }
}

