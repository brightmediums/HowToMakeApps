//
//  PaddingLabel.swift
//  AudioCloud
//
//  Created by Joshua Stephenson on 7/3/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//
/*
 Shamelessly stolen from: https://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel
 */

import UIKit

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

}
