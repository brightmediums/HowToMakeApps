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

class Sticker : UILabel {
    var constraintLeft: NSLayoutConstraint!
    var constraintTop: NSLayoutConstraint!
    var constraintHeight: NSLayoutConstraint!
    var originBeforeDragging: CGPoint!
    var workingHeight: CGFloat!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var stickerLion: Sticker!
    @IBOutlet weak var stickerPanda: Sticker!
    @IBOutlet weak var stickerKoala: Sticker!
    
    @IBOutlet weak var constraintLionTop: NSLayoutConstraint!
    @IBOutlet weak var constraintLionLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintLionHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintPandaTop: NSLayoutConstraint!
    @IBOutlet weak var constraintPandaLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintPandaHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintKoalaTop: NSLayoutConstraint!
    @IBOutlet weak var constraintKoalaLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintKoalaHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [stickerLion, stickerPanda, stickerKoala].forEach { (sticker) in
            if let sticker = sticker {
                sticker.layer.cornerRadius = sticker.frame.size.width / 2.0
            }
        }
        
        self.stickerLion.constraintLeft     = self.constraintLionLeft
        self.stickerLion.constraintTop      = self.constraintLionTop
        self.stickerPanda.constraintLeft    = self.constraintPandaLeft
        self.stickerPanda.constraintTop     = self.constraintPandaTop
        self.stickerKoala.constraintLeft    = self.constraintKoalaLeft
        self.stickerKoala.constraintTop     = self.constraintKoalaTop
        self.stickerLion.constraintHeight   = self.constraintLionHeight
        self.stickerPanda.constraintHeight  = self.constraintPandaHeight
        self.stickerKoala.constraintHeight  = self.constraintKoalaHeight
        
        self.stickerLion.originBeforeDragging = CGPoint(x: self.stickerLion.constraintLeft.constant, y: self.stickerLion.constraintTop.constant)
        
        self.stickerPanda.originBeforeDragging = CGPoint(x: self.stickerPanda.constraintLeft.constant, y: self.stickerPanda.constraintTop.constant)
        
        self.stickerKoala.originBeforeDragging = CGPoint(x: self.stickerKoala.constraintLeft.constant, y: self.stickerKoala.constraintTop.constant)
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

