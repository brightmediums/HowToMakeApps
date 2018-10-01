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

class ViewController: UIViewController, UIGestureRecognizerDelegate, StickerPickerDelegate, TextEntryDelegate {
    
    var activeSticker: Sticker?
    var allStickers: [Sticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openTextEditor(_ sender: Any) {
        let textEditor = self.storyboard?.instantiateViewController(withIdentifier: "TextEntry") as! TextEntryViewController
        textEditor.modalPresentationStyle = .overCurrentContext
        textEditor.delegate = self
        self.present(textEditor, animated: true, completion: nil)
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
        sticker.isUserInteractionEnabled = false
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
    
    // MARK: - TextEntryDelegate
    func didAdd(text: String) {
        self.dismiss(animated: true, completion: nil)
        self.add(stickerText: text)
    }
    

}

