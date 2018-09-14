//
//  ViewController.swift
//  Stickers Like Instagram Stories
//
//  Created by Joshua Stephenson on 8/17/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let defaultStickerWidthHeight = CGFloat(54.0)
let defaultFontSize = CGFloat(38.0)
let minimumOffsetForSwipeUp = CGFloat(100.0)

class Sticker: UILabel {
    var appliedTranslation  = CGPoint(x: 0.0, y: 0.0)
    var appliedScale        = CGFloat(1.0)
    var appliedRotation     = CGFloat(0.0)
    
    // Placement: Used to track how much translation has already been applied while the finger remains down
    var translation = CGPoint(x: 0.0, y: 0.0) {
        didSet { self.updateTransform() }
    }
    
    // Scale: Used to track how much scaling has already been applied
    var scale = CGFloat(1.0) {
        didSet { self.updateTransform() }
    }
    
    // Rotation: Used to track how much rotation is applied while fingers are down
    var rotation = CGFloat(0.0) {
        didSet { self.updateTransform() }
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

class ViewController: UIViewController, UIGestureRecognizerDelegate, StickerPickerDelegate {
    
    var activeSticker: Sticker?
    var allStickers: [Sticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openStickerPicker(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StickerPicker") as! StickerPickerViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    var waitingToExposeStickerPicker = false
    // For placing stickers
    @IBAction func didPanOnStory(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        
        if recognizer.state == .began {
            self.activeSticker = self.findSticker(point: recognizer.location(in: self.view))
            if let sticker = self.activeSticker {
                self.view.bringSubview(toFront: sticker)
            }else {
                waitingToExposeStickerPicker = true
            }
        }else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self.view)
            if let sticker = self.activeSticker {
                sticker.translation = translation
            }else{
                if waitingToExposeStickerPicker {
                    if fabs(translation.y) > fabs(translation.x)
                        && translation.y < (0.0 - minimumOffsetForSwipeUp) {
                        self.openStickerPicker(self)
                        waitingToExposeStickerPicker = false
                    }
                }
            }
        }else if recognizer.state == .ended {
            if let sticker = self.activeSticker {
                sticker.saveTranslation()
            }
            waitingToExposeStickerPicker = false
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
    
    private func add(stickerText: String){
        let frame = CGRect(x: 0.0, y: 0.0, width: defaultStickerWidthHeight, height: defaultStickerWidthHeight)
        let sticker = Sticker(frame: frame)
        sticker.font = UIFont(name: "Helvetica", size: defaultFontSize)
        sticker.text = stickerText
        
        self.view.addSubview(sticker)
        
        sticker.translatesAutoresizingMaskIntoConstraints = false
        sticker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sticker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.allStickers.append(sticker)
    }
    
    private func findSticker(point: CGPoint) -> Sticker? {
        var aSticker: Sticker? = nil
        self.allStickers.forEach { (sticker) in
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
    
    // MARK: - StickerPickerDelegate
    func didPick(sticker: String) {
        self.dismiss(animated: true, completion: nil)
        self.add(stickerText: sticker)
    }
    

}

