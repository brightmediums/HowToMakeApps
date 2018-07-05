//
//  WaveformImage.swift
//  AudioCloud
//
//  Created by Joshua Stephenson on 7/5/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

// Samples taken directly from the Soundcloud API response for Childish Gambino's: '3005'
let samples = [106, 77, 53, 15, 83, 80, 63, 43, 80, 81, 66, 75, 78, 57, 18, 73, 80, 70, 27, 82, 83, 70, 66, 78, 50, 30, 13, 77, 67, 40, 12, 76, 73, 73, 77, 63, 42, 12, 88, 77, 46, 14, 90, 83, 73, 79, 73, 34, 14, 87, 78, 53, 37, 79, 75, 19, 86, 74, 45, 14, 79, 81, 46, 14, 82, 76, 44, 69, 70, 37, 13, 80, 81, 48, 15, 76, 79, 41, 76, 75, 49, 26, 79, 78, 57, 18, 79, 78, 67, 80, 76, 57, 15, 80, 84, 123, 56, 80, 81, 123, 95, 101, 115, 88, 74, 83, 119, 90, 90, 90, 74, 77, 83, 89, 88, 66, 78, 126, 61, 45, 80, 121, 88, 100, 127, 88, 98, 93, 115, 94, 82, 88, 87, 80, 82, 86, 91, 92, 89, 117, 84, 45, 79, 113, 88, 96, 128, 92, 96, 95, 122, 100, 84, 91, 94, 84, 96, 100, 96, 81, 90, 121, 116, 58, 76, 118, 111, 91, 110, 93, 83, 104, 122, 104, 119, 106, 114, 95, 137, 139, 137, 137, 134, 135, 124, 127, 135, 139, 138, 134, 135, 133, 135, 132, 138, 136, 126, 134, 130, 120, 134, 138, 135, 128, 135, 135, 125, 125, 111, 138, 139, 133, 138, 135, 138, 138, 136, 136, 131, 128, 137, 134, 135, 138, 138, 138, 135, 128, 125, 134, 113, 137, 136, 138, 136, 133, 135, 138, 135, 134, 127, 130, 130, 137, 130, 139, 138, 137, 137, 137, 136, 134, 130, 138, 138, 138, 136, 133, 134, 139, 135, 131, 135, 138, 132, 127, 133, 138, 138, 129, 136, 135, 138, 132, 116, 134, 135, 135, 134, 134, 133, 138, 139, 134, 131, 123, 120, 124, 133, 137, 138, 137, 128, 131, 132, 131, 115, 112, 136, 134, 139, 132, 133, 139, 137, 135, 129, 102, 43, 114, 110, 131, 135, 137, 126, 135, 132, 128, 130, 113, 138, 137, 136, 137, 137, 137, 138, 138, 137, 135, 121, 134, 120, 130, 139, 139, 138, 138, 131, 132]

let containerHeight = CGFloat(200)

extension UIImage {

    // heart of the scrubber. this method draws the waveform as a UIImage
    static func waveformImage() -> UIImage {
        let containerWidth = CGFloat(samples.count) * (barSpacing + barWidth)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: containerWidth, height: containerHeight))
        
        let image = renderer.image { ctx in
            
            // We need to draw the top bars and the bottom bars separately since they have different fill colors
            // Rather than looping once and drawing twice each loop, drawing hundreds of times
            // We will loop twice and draw only twice
            var count = 0
            samples.forEach{ sample in
                let x = CGFloat(count) * (barWidth + barSpacing)
                
                // Draw the top "half" first
                let topHeight = CGFloat(sample) * topToBottomRatio
                let topY = (containerHeight * topToBottomRatio) - topHeight
                
                let topBar = CGRect(x: x, y: topY, width: barWidth, height: topHeight)
                ctx.cgContext.setFillColor(UIColor.white.cgColor)
                ctx.cgContext.addRect(topBar)
                
                count += 1
            }
            ctx.cgContext.drawPath(using: .fill)
            
            // Now for the bottom bars
            count = 0
            samples.forEach{ sample in
                let x = CGFloat(count) * (barWidth + barSpacing)
                
                // Draw the bottom "half"
                let bottomHeight = CGFloat(sample) - (CGFloat(sample) * topToBottomRatio)
                let bottomY = (containerHeight * topToBottomRatio) + verticalSpacing
                
                let bottomBar = CGRect(x: x, y: bottomY, width: barWidth, height: bottomHeight)
                ctx.cgContext.setFillColor(UIColor(white: 1.0, alpha: 0.9).cgColor)
                ctx.cgContext.addRect(bottomBar)
                
                count += 1
            }
            ctx.cgContext.drawPath(using: .fill)
        }
        
        return image
    }
}
