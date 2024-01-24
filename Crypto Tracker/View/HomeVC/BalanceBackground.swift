//
//  BalanceBackground.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 08.07.23.
//

import UIKit

class BalanceBackground {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer{
        return layer as! CAGradientLayer
    }
    
}
