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
let bottomRatio = CGFloat(2.0/3.0)
let waveformMargin = 30.0

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var coverArtScrollView: UIScrollView!
    @IBOutlet weak var waveformScrollView: UIScrollView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    func setupScrollView(){
        var json: JSON!
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
        
        let samples = json["samples"].arrayValue
        drawWaveForm(samples: samples, height: json["height"].intValue)
    }
    
    private func drawWaveForm(samples: [JSON], height: Int) {
        let containerHeight = CGFloat(height)
        let containerWidth = CGFloat(samples.count * (barWidth + barSpacing)) + self.view.frame.size.width
        print("count \(samples.count), containerWidth \(containerWidth), height \(containerHeight)")
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: containerWidth, height: containerHeight))
        var count = 0
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            samples.forEach { (sample) in
//            let sample = samples.first!
                let topHeight = CGFloat(sample.intValue) * bottomRatio
                let bottomHeight = CGFloat(sample.intValue) - topHeight
            
                let bottomY = containerHeight * bottomRatio + 1
                let topY = containerHeight * bottomRatio - topHeight
                
                let xOffset = self.view.frame.size.width / 2.0
                let x = CGFloat(count * (barWidth + barSpacing)) + xOffset
                let width = CGFloat(barWidth)
                
                let top = CGRect(x: x, y: topY, width: width, height: topHeight)
                ctx.cgContext.addRect(top)
            
                let bottom = CGRect(x: x, y: bottomY, width: width, height: bottomHeight)
                ctx.cgContext.addRect(bottom)
                count += 1
            }
            ctx.cgContext.drawPath(using: .fill)
        }
        let waveForm = UIImageView(image: img)
        self.waveformScrollView.addSubview(waveForm)
        self.waveformScrollView.contentSize = CGSize(width: containerWidth, height: self.waveformScrollView.frame.size.height)
        self.coverArtScrollView.contentSize = CGSize(width: containerWidth, height: self.view.frame.size.height)
        self.coverArtImageView.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.coverArtScrollView.contentSize)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//            view.backgroundColor = .clear
        
        if self.blurEffectView == nil{
            let blurEffect = UIBlurEffect(style: .dark)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            self.blurEffectView!.frame = self.view.bounds
            self.blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        view.insertSubview(blurEffectView!, aboveSubview: self.coverArtScrollView)
        UIView.animate(withDuration: 0.15) {
            self.labelConstraint.constant = 360.0
            self.timeLabel.backgroundColor = UIColor.clear
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.blurEffectView?.removeFromSuperview()
        UIView.animate(withDuration: 0.15) {
            self.labelConstraint.constant = 226.0
            self.timeLabel.backgroundColor = UIColor.black
            self.timeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.layoutIfNeeded()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        self.coverArtScrollView.setContentOffset(point, animated: false)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.waveformScrollView.setContentOffset(scrollView.contentOffset, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

