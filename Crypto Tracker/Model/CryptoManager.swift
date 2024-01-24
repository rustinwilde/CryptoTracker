import UIKit
import Combine
import Alamofire


class CryptoManager {
    
    static let shared = CryptoManager()
    var timer: Timer?
    
    private var cancellables: Set<AnyCancellable> = []
    
    var currentCryptoPrice: CryptoPrices?
    
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
    
    func getCryptoPrices(symbol: String) -> AnyPublisher<CryptoPrices, Error> {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(symbol)&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en"
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        return AF.request(urlRequest)
            .publishDecodable(type: [CryptoPrices].self, decoder: JSONDecoder())
            .tryMap { response in
                guard let cryptoPricesArray = response.value else {
                    throw AFError.responseValidationFailed(reason: .dataFileNil)
                }
                
                guard let cryptoPrice = cryptoPricesArray.first else {
                    throw NSError(domain: "Invalid response format", code: 0, userInfo: nil)
                }
                
                if let updatedPrice = cryptoPrice.current_price {
                    return CryptoPrices(current_price: updatedPrice)
                } else {
                    return CryptoPrices(current_price: nil)
                }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func startFetchingWithTimer(symbol: String) -> AnyPublisher<CryptoPrices, Error> {
        let timerPublisher = Timer.publish(every:  20, on: .main, in: .common)
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
    
     func fetchCryptoPrices(symbol: String) -> AnyPublisher<CryptoPrices, Error> {
        getCryptoPrices(symbol: symbol)
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
    private var subscriptions = Set<AnyCancellable>()
    
}




