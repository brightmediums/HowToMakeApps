//
//  ViewController.swift
//  AudioScrubber
//
//  Created by Joshua Stephenson on 6/21/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import SwiftyJSON

let barWidth = 2
let barSpacing = 1
let topToBottomRatio = CGFloat(2.0/3.0)
let waveformMargin = 30.0

extension UIImage {
    
    func tint(with color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        
        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var coverArtScrollView: UIScrollView!
    @IBOutlet weak var waveformScrollView: UIScrollView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    var waveformImageView: UIImageView?
    var blurEffectView: UIVisualEffectView?
    
    /**
     - Parameters active sets UI to active based on scrollview interaction
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
        setupScrollView()
        setupBlurView()
    }
    
    func setupScrollView(){
        var json: JSON?
        if let path = Bundle.main.path(forResource: "waveform_data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                json = try JSON(data: data)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        if let samples = json?["samples"].arrayValue, let height = json?["height"].intValue {
            drawWaveForm(samples: samples, height: height)
        }
    }
    
    func setupBlurView() {
        if self.blurEffectView == nil{
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView!.frame = self.view.bounds
            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        view.insertSubview(blurEffectView!, aboveSubview: self.coverArtScrollView)
        self.blurEffectView?.isHidden = true
    }
    
    private func drawWaveForm(samples: [JSON], height: Int) {
        let containerHeight = CGFloat(height)
        let containerWidth = CGFloat(samples.count * (barWidth + barSpacing))
        
        // Renderer will draw a static image for us
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: containerWidth, height: containerHeight))
        
        // We will keep a bar count so we can calculate the x position
        var count = 0
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            samples.forEach { (sample) in
                
                /*
                 Get the top bar height by multiplying the sample value by 2/3 and then the bottom is the remaining value
                 */
                let topHeight = CGFloat(sample.intValue) * topToBottomRatio
                let bottomHeight = CGFloat(sample.intValue) - topHeight
            
                /*
                 CoreGraphics uses an inverted Y axis so the initial Y of the bottom bar is our waveform "midline" set by the topToBottomRatio
                 The initial Y of the top bar is the height of the top bar subtracted from the "midline"
                 */
                let bottomY = containerHeight * topToBottomRatio + 1
                let topY = containerHeight * topToBottomRatio - topHeight
                
                /*
                 Simply move each bar over by the bar's width plus the bar spacing
                 */
                let x = CGFloat(count * (barWidth + barSpacing))
                let width = CGFloat(barWidth)
                
                // Make the top bar
                let topBar = CGRect(x: x, y: topY, width: width, height: topHeight)
                ctx.cgContext.addRect(topBar)
            
                // Make the bottom Bar
                let bottomBar = CGRect(x: x, y: bottomY, width: width, height: bottomHeight)
                ctx.cgContext.addRect(bottomBar)
                
                count += 1
            }
            ctx.cgContext.drawPath(using: .fill)
        }
        // Waveform is returned as a static image and we display it here
        self.waveformImageView = UIImageView(image: img)
        self.waveformScrollView.addSubview(self.waveformImageView!)
        
        // Make sure the waveform scrollview content size matches the image size
        self.waveformScrollView.contentSize = CGSize(width: containerWidth, height: self.waveformScrollView.frame.size.height)
        
        // Waveform starts at mid-screen (horizontally) when the audio starts, so we need some left/right padding (insets)
        self.waveformScrollView.contentInset = UIEdgeInsetsMake(0, self.view.frame.size.width / 2.0, 0.0, self.view.frame.size.width / 2.0)
        
        // Cover Art is a square that fills the vertical area. Width then matcheds the height.
        self.coverArtScrollView.contentSize = CGSize(width: self.view.frame.size.height, height: self.view.frame.size.height)
        
        // Scrollview should initially be scrolled to the left (into the inset)
        self.waveformScrollView.setContentOffset(CGPoint(x: 0.0 - self.waveformScrollView.frame.size.width / 2.0, y: 0.0), animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.active = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.active = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let newX: CGFloat
        if point.x < 1.0 {
            newX = 0.0
        }else {
            let factor = scrollView.contentSize.width / scrollView.frame.size.width 
            newX = point.x / factor
        }
        let offset = CGPoint(x: newX, y: 0.0)
        self.coverArtScrollView.setContentOffset(offset, animated: false)
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

