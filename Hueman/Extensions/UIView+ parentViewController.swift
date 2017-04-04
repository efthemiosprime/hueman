//
//  UIView+ parentViewController.swift
//  Hueman
//
//  Created by Efthemios Prime on 4/3/17.
//  Copyright © 2017 Efthemios Prime. All rights reserved.
//

import Foundation

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
