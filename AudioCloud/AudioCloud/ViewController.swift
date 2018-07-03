//
//  ViewController.swift
//  AudioCloud
//
//  Created by Joshua Stephenson on 7/2/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

let animationDuration       = 0.25
let scaleFactor             = CGFloat(1.4)
let springDamping           = CGFloat(0.5)
let initialSpringVelocity   = CGFloat(0.5)

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var coverArtScrollView: UIScrollView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var waveformScrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var blurEffectView: UIVisualEffectView?
    
    var active: Bool = false {
        didSet {
            if active {
                // set UI to active
                UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: initialSpringVelocity, options: .curveEaseIn, animations: {
                    self.blurEffectView?.alpha = 1.0
                    let yTransform = CGAffineTransform(translationX: 0.0, y: -100.0)
                    let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                    self.timeLabel.transform = yTransform.concatenating(scaleTransform)
                    self.timeLabel.backgroundColor = UIColor.clear
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else {
                // set UI to inactive
                UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springDamping, initialSpringVelocity: initialSpringVelocity, options: .curveLinear, animations: {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.active = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.active = false
    }

    // Move the cover art scrollview when the waveform scrollview moves
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        
        // we add half the width of the scrollview to account for the insets we added in WaveformScrollView
        // that inset is what makes the waveform start mid-screen (horizontally) rather than x=0
        let modifiedX = point.x + (scrollView.frame.size.width / 2.0)
        
        // We get the difference in width between (the scrollview's content width plus the left inset)
        // and the width of the scrollview
        let factor = (scrollView.contentSize.width + scrollView.frame.size.width / 2.0) / scrollView.frame.size.width
        
        // Use that factor to set the new offset for the cover art
        let newX = modifiedX / factor
        var coverArtOffset = self.coverArtScrollView.contentOffset
        coverArtOffset.x = newX
        
        self.coverArtScrollView.setContentOffset(coverArtOffset, animated: false)
    }
    
    // Disable scrollview inertia
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.waveformScrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }

    // Basic blur view inserted above the cover art
    func setupBlurView() {
        if self.blurEffectView == nil{
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView!.frame = self.view.bounds
            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(self.blurEffectView!, aboveSubview: self.coverArtScrollView)
        }
        self.blurEffectView?.alpha = 0.0
    }
}

