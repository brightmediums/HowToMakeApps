//
//  Sticker.swift
//  Stickers Like Instagram Stories
//
//  Created by Joshua Stephenson on 10/1/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit


let defaultLabelFont = UIFont(name: "Helvetica", size: defaultFontSize)

class Sticker: UIView {
    var appliedTranslation  = CGPoint(x: 0.0, y: 0.0)
    var appliedScale        = CGFloat(1.0)
    var appliedRotation     = CGFloat(0.0)
    
    var label: UILabel?
    var text: String? {
        didSet {
            label = UILabel(frame: self.frame)
            if let label = label {
                label.text = text
                label.font = defaultLabelFont
                label.textColor = UIColor.white
                label.isUserInteractionEnabled = false
                self.addSubview(label)
            }
        }
    }
    
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
    
    override var intrinsicContentSize: CGSize {
        get {
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 1
            label?.sizeToFit()
            return label!.frame.size
        }
    }
    
    private func updateTransform() {
        let translationTransform    = CGAffineTransform(translationX: self.translation.x + appliedTranslation.x, y: self.translation.y + appliedTranslation.y)
        let scaleTransform          = CGAffineTransform(scaleX: scale * appliedScale, y: scale * appliedScale)
        let rotationTransform       = CGAffineTransform(rotationAngle: rotation + appliedRotation)
        
        self.transform = rotationTransform.concatenating(scaleTransform).concatenating(translationTransform)
    }
}
