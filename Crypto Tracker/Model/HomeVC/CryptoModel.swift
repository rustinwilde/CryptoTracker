//
//  APIManager.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 31.08.23.
//

import Foundation



struct CryptoModel{
    
    var cryptoID: Int
    var cryptoImage: String
    var cryptoSymbol: String
    var cryptoName: String
    var cryptoPrice: Double
    var cryptoChange: Double
    
    enum CryptoAPI{
        case bitcoin
        case etherium
        case ripple
    }
    
    
    
    
}
