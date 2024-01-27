//
//  CustomTextField.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 26.01.24.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.borderStyle = .roundedRect
        self.backgroundColor = .white
        self.textColor = UIColor.darkText
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
    }
    
    
}
