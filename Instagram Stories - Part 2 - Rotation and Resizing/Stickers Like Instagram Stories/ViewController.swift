//
//  ViewController.swift
//  Stickers Like Instagram Stories
//
//  Created by Joshua Stephenson on 8/17/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class Sticker: UIImageView {
    var appliedTranslation  = CGPoint(x: 0.0, y: 0.0)
    var appliedScale        = CGFloat(1.0)
    var appliedRotation     = CGFloat(0.0)
    
    // Placement: Used to track how much translation has already been applied while the finger remains down
    var translation = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            self.updateTransform()
        }
    }
    
    // Scale: Used to track how much scaling has already been applied
    var scale = CGFloat(1.0) {
        didSet {
            self.updateTransform()
        }
    }
    
    // Rotation: Used to track how much rotation is applied while fingers are down
    var rotation = CGFloat(0.0) {
        didSet {
            self.updateTransform()
        }
    }
    
    func saveScale() {
        self.appliedScale = self.appliedScale * scale
        self.scale = CGFloat(1.0)
    }
    
    func saveTranslation() {
        self.appliedTranslation.x += translation.x
        self.appliedTranslation.y += translation.y
        translation = CGPoint(x: 0.0, y: 0.0)
    }
    
    func saveRotation() {
        self.appliedRotation = rotation
        rotation = CGFloat(0.0)
    }
    
    private func updateTransform() {
        let translationTransform    = CGAffineTransform(translationX: self.translation.x + appliedTranslation.x, y: self.translation.y + appliedTranslation.y)
        let scaleTransform          = CGAffineTransform(scaleX: scale * appliedScale, y: scale * appliedScale)
        let rotationTransform       = CGAffineTransform(rotationAngle: rotation + appliedRotation)
        
        self.transform = rotationTransform.concatenating(scaleTransform).concatenating(translationTransform)
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var stickerMonkey: Sticker!
    @IBOutlet weak var stickerTaco: Sticker!
    @IBOutlet weak var stickerFlower: Sticker!
    
    var activeSticker: Sticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // For placing stickers
    @IBAction func didPanOnStory(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        
        if recognizer.state == .began {
            self.activeSticker = self.findSticker(point: recognizer.location(in: self.view))
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }
        }else if recognizer.state == .changed {
            if let sticker = self.activeSticker {
                let translation = recognizer.translation(in: self.view)
                sticker.translation = translation
            }
        }else if recognizer.state == .ended {
            if let sticker = self.activeSticker {
                sticker.saveTranslation()
            }
        }
    }
    
    // For scaling (resizing) stickers
    @IBAction func didPinchOnStory(_ sender: Any) {
        let recognizer = sender as! UIPinchGestureRecognizer
        
        if recognizer.state == .began {
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }
        }else if recognizer.state == .changed {
            if let sticker = self.activeSticker {
                sticker.scale = recognizer.scale
            }
        }else if recognizer.state == .ended {
            if let sticker = self.activeSticker {
                sticker.saveScale()
            }
        }
    }
    
    // Fo rotating stickers
    @IBAction func didRotateOnStory(_ sender: Any) {
        let recognizer = sender as! UIRotationGestureRecognizer
        
        if recognizer.state == .began {
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }
        }else if recognizer.state == .changed {
            if let sticker = self.activeSticker {
                sticker.rotation = recognizer.rotation
            }
        }else if recognizer.state == .ended {
            if let sticker = self.activeSticker {
                sticker.saveRotation()
            }
        }
    }
    
    private func findSticker(point: CGPoint) -> Sticker? {
        var aSticker: Sticker? = nil
        let stickers: [Sticker] = [stickerMonkey, stickerTaco, stickerFlower]
        stickers.forEach { (sticker) in
            if sticker.frame.contains(point) {
                aSticker = sticker
            }
        }
        return aSticker
    }
    
    // MARK: - Gesture Recognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

