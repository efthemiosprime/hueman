//
//  AutoLabel.swift
//  Hueman
//
//  Created by Efthemios Prime on 10/18/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

class AutoLabel: UILabel {

    override public var text: String? {
        didSet {
            layoutIfNeeded()
        }
    }
    override var bounds: CGRect {
        didSet {
            if (bounds.size.width != self.bounds.size.width) {
                self.setNeedsUpdateConstraints();
                
            }
        }
    }
    
    override func updateConstraints() {
        if(self.preferredMaxLayoutWidth != self.bounds.size.width) {
            self.preferredMaxLayoutWidth = self.bounds.size.width
        }
        super.updateConstraints()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
