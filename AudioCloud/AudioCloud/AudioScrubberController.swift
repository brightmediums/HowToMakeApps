//
//  AudioScrubberController.swift
//  AudioCloud
//
//  Created by Joshua Stephenson on 7/5/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

// Some constants that will define our waveform
let barWidth = CGFloat(2)
let barSpacing = CGFloat(1.5)
let topToBottomRatio = CGFloat(2.0 / 3.0)
let verticalSpacing = CGFloat(1.0)

// This defines how this VC communicates with the main VC
protocol ScrubberDelegate {
    /**
     factor is a percent representing amount of content that has been scrolled
     */
    func progressUpdatedTo(progress: CGFloat)
    var active: Bool { get set}
}

@IBDesignable class AudioScrubberController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var maskedViewLeftSide: UIView!
    @IBOutlet weak var maskedViewRightSide: UIView!
    @IBOutlet weak var maskView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var maskedWaveformView: UIView!
    var waveformView: UIImageView!
    
    // Set this to false to match SoundCloud's functionality
    var inertiaEnabled: Bool = true
    
    var scrubberDelegate: ScrubberDelegate?
    
    // MARK: - UIView Basics
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.inertiaEnabled = false
        
        let image = UIImage.waveformImage()
        waveformView = UIImageView(image: image)
        waveformView.frame.size = image.size
        waveformView.translatesAutoresizingMaskIntoConstraints = false
        maskView.addSubview(waveformView)
        
        maskView.contentInset = UIEdgeInsetsMake(0, self.view.frame.size.width / 2.0, 0.0, self.view.frame.size.width / 2.0)
        maskView.contentSize = image.size
        maskView.frame.size = image.size
        
        scrollView.contentInset = maskView.contentInset
        scrollView.contentSize = maskView.contentSize
        
        maskedViewLeftSide.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "WaveformGradient-Left"))
        maskedViewRightSide.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "WaveformGradient-Right"))
        maskedWaveformView.mask = maskView
    }

    // We need to get access to the parent VC as our scrubber delegate
    // View containment provides a method to do that
    override func didMove(toParentViewController parent: UIViewController?) {
        self.scrubberDelegate = parent as? ScrubberDelegate
    }

    // MARK: - ScrollView Delegate
    // Disable scrolling inertia
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if !inertiaEnabled {
            self.scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        }
    }
    
    // We need to programmatically make the offset of the masked waveform match the offset of the main scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        maskView.contentOffset = offset
        
        notifyDelegateOfScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrubberDelegate?.active = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !inertiaEnabled || (inertiaEnabled && !decelerate) {
            scrubberDelegate?.active = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrubberDelegate?.active = false
    }
    
    private func notifyDelegateOfScroll() {
        let point = scrollView.contentOffset
        let offsetInPercent = (point.x + scrollView.contentInset.left) / scrollView.contentSize.width
        scrubberDelegate?.progressUpdatedTo(progress: offsetInPercent)
    }
}
