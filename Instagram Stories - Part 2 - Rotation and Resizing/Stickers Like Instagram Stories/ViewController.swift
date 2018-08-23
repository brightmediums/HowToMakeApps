//
//  ViewController.swift
//  Stickers Like Instagram Stories
//
//  Created by Joshua Stephenson on 8/17/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class FingerCounterRecognizer: UIGestureRecognizer {
    var multipleTouchesActive: Bool = false {
        didSet {
            if multipleTouchesActive {
                print("Multiple Touches Detected")
            }else {
                print("Only one finger")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("number of touches \(numberOfTouches)")
        multipleTouchesActive = numberOfTouches > 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        multipleTouchesActive = false
    }
}

class Sticker: UIImageView {
    var constraintTop: NSLayoutConstraint!
    var constraintLeft: NSLayoutConstraint!
    
    // Placement: Used to track how much translation has already been applied while the finger remains down
    var translation = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            self.updateTransforms()
        }
    }
    
    // Rotation: Used to track how much rotation has already been applied between rotations
    var rotation = CGFloat(0.0) {
        didSet {
            self.updateTransforms()
        }
    }
    
    // Scale: Used to track how much scaling has already been applied
    var scale = CGFloat(1.0) {
        didSet {
            self.updateTransforms()
        }
    }
    
    private func updateTransforms() {
        let translationTransform    = CGAffineTransform(translationX: self.translation.x, y: translation.y)
        let scaleTransform          = CGAffineTransform(scaleX: scale, y: scale)
        let rotationTransform       = CGAffineTransform(rotationAngle: self.rotation)
        self.transform = translationTransform.concatenating(scaleTransform).concatenating(rotationTransform)
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var stickerMonkey: Sticker!
    @IBOutlet weak var stickerTaco: Sticker!
    @IBOutlet weak var stickerFlower: Sticker!
    
    @IBOutlet weak var constraintMonkeyLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintMonkeyTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintTacoTop: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerLeft: NSLayoutConstraint!
    @IBOutlet weak var constraintFlowerTop: NSLayoutConstraint!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    var multipleTouchesActive: Bool = false {
        didSet {
//            if multipleTouchesActive {
//                print("MULTIPLE TOUCHES NOW ACTIVE=====")
//            }else {
//                print("================NO LONGER ACTIVE")
//            }
        }
    }
    
    var activeSticker: Sticker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stickerMonkey.constraintLeft = constraintMonkeyLeft
        self.stickerMonkey.constraintTop = constraintMonkeyTop
        
        self.stickerFlower.constraintLeft = constraintFlowerLeft
        self.stickerFlower.constraintTop = constraintFlowerTop
        
        self.stickerTaco.constraintLeft = constraintTacoLeft
        self.stickerTaco.constraintTop = constraintTacoTop
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
            self.panSticker(recognizer: recognizer)
        }else if recognizer.state == .ended {
            if let sticker = self.activeSticker {
                
            }
        }
    }
    
    
    // For rotating stickers
    @IBAction func didRotateOnStory(_ sender: Any) {
        let recognizer = sender as! UIRotationGestureRecognizer
        
        if recognizer.state == .began {
            self.multipleTouchesActive = true
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }
        }else if recognizer.state == .changed {
            if let sticker = self.activeSticker {
                sticker.rotation = recognizer.rotation
            }
        }else if recognizer.state == .ended {
            self.multipleTouchesActive = false
        }
    }
    
    // For scaling (resizing) stickers
    @IBAction func didPinchOnStory(_ sender: Any) {
        let recognizer = sender as! UIPinchGestureRecognizer
        
        if recognizer.state == .began {
            self.multipleTouchesActive = true
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }
        }else if recognizer.state == .changed {
            if let sticker = self.activeSticker {
                sticker.scale = recognizer.scale
            }
        }else if recognizer.state == .ended {
            self.multipleTouchesActive = false
        }
    }
    
    
    // MARK: - Private
    private func panSticker(recognizer: UIPanGestureRecognizer){
        if self.multipleTouchesActive{
            return
        }
        if let sticker = self.activeSticker {
            let translation = recognizer.translation(in: self.view)
            sticker.translation = translation
        }
    }
    
    private func findSticker(point: CGPoint) -> Sticker? {
        var activeSticker: Sticker? = nil
        let stickers = [stickerMonkey, stickerTaco, stickerFlower]
        stickers.forEach { (sticker) in
            let newPoint = self.view.convert(point, to: sticker)
            if newPoint.x > 0 && newPoint.x < sticker!.frame.size.width {
                if newPoint.y > 0 && newPoint.y < sticker!.frame.size.width {
                    activeSticker = sticker
                }
            }
        }
        return activeSticker
    }
    
    // MARK: - Gesture Recognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

