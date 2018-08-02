//
//  ViewController.swift
//  AudioCloud
//
//  Created by Joshua Stephenson on 7/2/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

// animation configuration
let animationDuration       = 0.25
let scaleFactor             = CGFloat(1.4)

class ViewController: UIViewController, UIScrollViewDelegate, ScrubberDelegate {

    @IBOutlet weak var coverArtScrollView: UIScrollView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var blurEffectView: UIVisualEffectView?
    
    // UI respond's when the user is scrolling the waveform by
    // animating the time label and blurring the background
    var active: Bool = false {
        didSet {
            if active {
                // set UI to active
                UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                    self.blurEffectView?.alpha = 1.0
                    let yTransform = CGAffineTransform(translationX: 0.0, y: -100.0)
                    let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                    self.timeLabel.transform = yTransform.concatenating(scaleTransform)
                    self.timeLabel.backgroundColor = UIColor.clear
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else {
                // set UI to inactive
                UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
                    self.blurEffectView?.alpha = 0.0
                    let yTransform = CGAffineTransform(translationX: 0.0, y: 0.0)
                    let scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.timeLabel.transform = yTransform.concatenating(scaleTransform)
                    self.timeLabel.backgroundColor = UIColor.black
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
    }
    
    // MARK: - Blur view
    private func setupBlurView() {
        if self.blurEffectView == nil{
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView!.frame = self.view.bounds
            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(self.blurEffectView!, aboveSubview: self.coverArtScrollView)
        }
        self.blurEffectView?.alpha = 0.0
    }
    
    // MARK: - Scrubber Delegate
    // Move the cover art scrollview when the waveform scrollview moves
    func progressUpdatedTo(progress: CGFloat) {
        let newX = (coverArtScrollView.contentSize.width - coverArtScrollView.frame.size.width) * progress
        let coverArtOffset = CGPoint(x: newX, y: 0.0)
        coverArtScrollView.contentOffset = coverArtOffset
    }
}
