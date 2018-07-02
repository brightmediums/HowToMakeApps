//
//  WaveformView.swift
//  AudioScrubber
//
//  Created by Joshua Stephenson on 7/2/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit
import SwiftyJSON

let barWidth = 2
let barSpacing = 1
let topToBottomRatio = CGFloat(2.0/3.0)

class WaveformView: UIScrollView {

    var waveformImageView: UIImageView?
    
    func loadWaveform() {
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
        self.addSubview(self.waveformImageView!)
        
        // Make sure the waveform scrollview content size matches the image size
        self.contentSize = CGSize(width: containerWidth, height: self.frame.size.height)
        
        // Waveform starts at mid-screen (horizontally) when the audio starts, so we need some left/right padding (insets)
        self.contentInset = UIEdgeInsetsMake(0, self.frame.size.width / 2.0, 0.0, self.frame.size.width / 2.0)
        
        // Scrollview should initially be scrolled to the left (into the inset)
        self.setContentOffset(CGPoint(x: 0.0 - self.frame.size.width / 2.0, y: 0.0), animated: false)
    }
}
