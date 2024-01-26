//
//  CryptoData.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 14.01.24.
//

import Foundation

struct CryptoData: Codable {
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

struct CryptoDataPrice: Decodable {
    var coin: Coin
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKey.self)
        let keys = container.allKeys
        guard let dynamicKey = keys.first else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: container.codingPath, debugDescription: "No keys found in the container.")
            )
        }
        coin = try container.decode(Coin.self, forKey: dynamicKey)
    }
    
    private struct DynamicKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
}

struct Coin: Codable {
    let usd: Double?
    
    enum CodingKeys: String, CodingKey {
        case usd
    }
}



