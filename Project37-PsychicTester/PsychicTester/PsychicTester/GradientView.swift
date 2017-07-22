//
//  GradientView.swift
//  PsychicTester
//
//  Created by Steven Sherry on 7/22/17.
//  Copyright © 2017 Steven Sherry. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var bottomColor: UIColor = .black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }

}
