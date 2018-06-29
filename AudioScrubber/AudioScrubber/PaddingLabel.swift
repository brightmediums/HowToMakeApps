//
//  MarginLabel.swift
//  AudioScrubber
//
//  Created by Joshua Stephenson on 6/29/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0.0, left: leftInset, bottom: 0.0, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + 0.0 + 0.0)
    }    

}
