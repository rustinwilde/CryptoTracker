//
//  CryptoInfo.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 07.07.23.
//

import UIKit

class CryptoInfo {
    var cryptoImage: UIImage?
    var cryptoName: String
    var cryptoCode: String
    var cryptoRate: Double
    
    init(cryptoImage: UIImage? = nil, cryptoName: String, cryptoCode: String, cryptoRate: Double) {
        self.cryptoImage = cryptoImage
        self.cryptoName = cryptoName
        self.cryptoCode = cryptoCode
        self.cryptoRate = cryptoRate
    }
}
