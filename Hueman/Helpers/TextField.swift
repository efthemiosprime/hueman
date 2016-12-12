//
//  TextField.swift
//  Hueman
//
//  Created by Efthemios Prime on 12/11/16.
//  Copyright © 2016 Efthemios Prime. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
    
    // text position
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , insetX , insetY)
    }
    

}
