//
//  CryptoData.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 14.01.24.
//

import Foundation

struct CryptoData: Decodable {
    let id, symbol, name: String?
    let image: String?
    let current_price: Double?
    let price_change_percentage_24h: Double?
    
    var cryptoPriceString: String {
        return "\(current_price ?? 0.0)$"
    }
    
    var cryptoChangeString: String {
        return String(format: "%.3f", price_change_percentage_24h ?? 0.0) + "%"
    }
    
}

struct CryptoPrices: Decodable {
    var current_price: Double?
    mutating func update(current_price: Double) -> CryptoPrices {
        self.current_price = current_price
        return self
    }
}

struct CryptoCoordinates: Decodable {
    let x: Int?
    let y: Double?
}



