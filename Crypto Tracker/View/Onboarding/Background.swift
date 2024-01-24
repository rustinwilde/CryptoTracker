//
//  Background.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 05.07.23.
//

import UIKit
import QuartzCore

class AnimatedQradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer{
        return layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradientLayer()
    }
    
    let color1: CGColor = UIColor(red: 36/255, green: 21/255, blue: 81/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 76/255, green: 70/255, blue: 164/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 103/255, green: 129/255, blue: 191/255, alpha: 1).cgColor
    let color4: CGColor = UIColor(red: 12/255, green: 228/255, blue: 163/255, alpha: 1).cgColor
    
    
    private func setupGradientLayer() {
        let initialColors = [color1, color2, color3, color4]
        gradientLayer.colors = initialColors
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = initialColors
        colorAnimation.toValue = [color4, color3, color2, color1]
        colorAnimation.duration = 5
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true
        
        gradientLayer.add(colorAnimation, forKey: "colorAnimation")
    }
    
}
