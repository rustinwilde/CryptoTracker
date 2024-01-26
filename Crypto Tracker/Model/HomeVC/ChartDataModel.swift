//
//  ChartDataModel.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 23.01.24.
//

import UIKit

struct ChartDataModel {
    var coordinates: [[CryptoCoordinates]]
    
    init(prices: [[Any]]) {
        coordinates = prices.map { dataPoint in
            let x = dataPoint.first as? Int ?? 0
            let y = dataPoint.last as? Double ?? 0.0
            return [CryptoCoordinates(x: x, y: y)]
        }
    }
    
    
    mutating func fetchCoordinates(symbol: String, onCompletion: @escaping ([CryptoCoordinates]) -> Void) {
        let coordinatesUrl = "https://api.coingecko.com/api/v3/coins/\(symbol)/market_chart?vs_currency=usd&days=1"
        let url = URL(string: coordinatesUrl)!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let cryptoCoordinates = try? JSONDecoder().decode([CryptoCoordinates].self, from: data) else {
                print("Couldn't decode JSON coordinates")
                return
            }

            onCompletion(cryptoCoordinates)
        }
        task.resume()
    }
}
