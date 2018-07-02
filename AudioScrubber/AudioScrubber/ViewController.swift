//
//  ViewController.swift
//  AudioScrubber
//
//  Created by Joshua Stephenson on 6/21/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var coverArtScrollView: UIScrollView!
    @IBOutlet weak var waveformScrollView: WaveformView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    var blurEffectView: UIVisualEffectView?
    
    /**
     - Parameters active sets UI to active:
     -- cover art is blurred
     -- time label is moved up, background color is removed and font size increased
     */
    var active: Bool = false {
        didSet {
            if active {
                self.blurEffectView?.isHidden = false
                UIView.animate(withDuration: 0.15) {
                    self.labelConstraint.constant = 360.0
                    self.timeLabel.backgroundColor = UIColor.clear
                    self.timeLabel.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                    self.view.layoutIfNeeded()
                }
            }else{
                self.blurEffectView?.isHidden = true
                UIView.animate(withDuration: 0.15) {
                    self.labelConstraint.constant = 226.0
                    self.timeLabel.backgroundColor = UIColor.black
                    self.timeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.view.layoutIfNeeded()
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waveformScrollView.loadWaveform()
        setupBlurView()
        
        // Cover Art is a square that fills the vertical area. Width then matches the height.
        self.coverArtScrollView.contentSize = CGSize(width: self.view.frame.size.height, height: self.view.frame.size.height)
    }
    
    func setupBlurView() {
        if self.blurEffectView == nil{
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView!.frame = self.view.bounds
            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurEffectView!, aboveSubview: self.coverArtScrollView)
        }
        self.blurEffectView?.isHidden = true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.active = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.active = false
    }
    
    /*
     When the waveform scrollview scrolls, use it's relative position to update
     the position of the cover art scroll view
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let newX: CGFloat
        if point.x < 1.0 {
            newX = 0.0
        }else {
            let factor = scrollView.contentSize.width / scrollView.frame.size.width 
            newX = point.x / factor
        }
        let coverArtOffset = CGPoint(x: newX, y: 0.0)
        self.coverArtScrollView.setContentOffset(coverArtOffset, animated: false)
    }
    
    // to disable scrollview inertia
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.waveformScrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

