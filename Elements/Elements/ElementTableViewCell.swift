//
//  ElementTableViewCell.swift
//  Elements
//
//  Created by Joshua Stephenson on 5/16/18.
//  Copyright © 2018 Bright Mediums. All rights reserved.
//

import UIKit

class ElementTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var element: Element! {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 3
            self.symbolLabel.text   = element.symbol
            self.nameLabel.text     = element.name
            self.weightLabel.text   = formatter.string(from: element.weight)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
