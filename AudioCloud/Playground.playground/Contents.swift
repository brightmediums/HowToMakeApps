//: Playground - noun: a place where people can play

import UIKit

let barWidth = CGFloat(20)
let barSpacing = CGFloat(5)
let topToBottomRatio = CGFloat(2.0 / 3.0)

let samples = [100, 50, 10, 200]

let containerHeight = CGFloat(200)
let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: containerHeight))

let image = renderer.image { ctx in
    ctx.cgContext.setFillColor(UIColor.blue.cgColor)
    
    var count = 0
    samples.forEach { sample in
        let x = CGFloat(count) * (barWidth + barSpacing)
        let topHeight = CGFloat(sample) * topToBottomRatio
        let topY = (containerHeight * topToBottomRatio) - topHeight
        let topBar = CGRect(x: CGFloat(x), y: topY, width: barWidth, height: topHeight)
        ctx.cgContext.addRect(topBar)
        
        let bottomHeight = CGFloat(sample) - topHeight
        let bottomY = topY + topHeight + barSpacing
        let bottomBar = CGRect(x: x, y: bottomY, width: barWidth, height: bottomHeight)
        ctx.cgContext.addRect(bottomBar)
        count += 1
    }
    ctx.cgContext.drawPath(using: .fill)
}

image
