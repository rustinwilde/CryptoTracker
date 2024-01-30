import UIKit
import Combine


class CryptoManager {
    
    static let shared = CryptoManager()
    var timer: Timer?
        
    func fetchCryptoData(onCompletion: @escaping ([CryptoData]) -> ()){
        let cryptoUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false"
        let url = URL(string: cryptoUrl)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let cryptoData = try? JSONDecoder().decode([CryptoData].self, from: data) else {
                print("Couldn't decode JSON")
                return
            }
            onCompletion(cryptoData)
            print("Closure - \(cryptoData)")
        }
        task.resume()
    }
    
    func loadImage(from cryptoData: CryptoData, onCompletion: @escaping (UIImage?) -> ()) {
        guard let imageUrlString = cryptoData.image,
              let imageUrl = URL(string: imageUrlString) else {
            print("Ошибка создания URL изображения")
            onCompletion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки изображения: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            
            if let image = UIImage(data: data){
                onCompletion(image)
            } else {
                print("Ошибка создания изображения из загруженных данных")
            }
        }.resume()
    }
    
    func getCryptoPrices(symbol: String) -> AnyPublisher<CryptoDataPrice, Error> {
        let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=\(symbol)&vs_currencies=usd")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                let (data, response) = output
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print(String(data: data, encoding: .utf8) ?? "")
                
                return data
            }
            .decode(type: CryptoDataPrice.self, decoder: JSONDecoder())
            .map { cryptoDataPrice in
                return cryptoDataPrice
            }
            .eraseToAnyPublisher()
    }
    
    func startFetchingWithTimer(symbol: String) -> AnyPublisher<CryptoDataPrice, Error> {
        let timerPublisher = Timer.publish(every:  60, on: .main, in: .common)
            .autoconnect()
            .map { _ in () }
        
        return timerPublisher
            .flatMap { _ in
                self.fetchCryptoPrices(symbol: symbol)
                    .handleEvents(receiveOutput: { cryptoPrices in
                        print("Received crypto prices: \(cryptoPrices)")
                    })
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCryptoPrices(symbol: String) -> AnyPublisher<CryptoDataPrice, Error> {
        getCryptoPrices(symbol: symbol)
            .map { cryptoDataPrice in
                var updatedCryptoDataPrice = cryptoDataPrice
                updatedCryptoDataPrice.coin = Coin(usd: cryptoDataPrice.coin.usd)
                return updatedCryptoDataPrice
            }
        
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching crypto prices: \(error)")
                case .finished:
                    break
                }
            })
            .eraseToAnyPublisher()
    }
}




