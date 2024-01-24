//
//  Button.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 05.07.23.
//

import Foundation
import UIKit

class Button : UIButton {
    
    let button = UIButton()
    
    func setup(title: String, customBackroundColor: UIColor, cornerRadius: Double){
        button.titleLabel?.text = title
        button.backgroundColor = customBackroundColor
        button.layer.cornerRadius = cornerRadius
    }
}
