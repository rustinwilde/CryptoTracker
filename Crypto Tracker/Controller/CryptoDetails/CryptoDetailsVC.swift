//
//  CryptoDetailsVC.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 13.07.23.
//

import UIKit
import UserNotifications
import Combine
import Charts


class CryptoDetailsVC: UIViewController {
    
    @IBOutlet weak var labelViewRates: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var cryptoSymbol: UILabel!
    @IBOutlet weak var cryptoChanges: UILabel!
    
    private let cryptoManager: CryptoManager
    private var userNotificationCenter: UNUserNotificationCenter
    private var notificationSent = false
    private var subscriptions = Set<AnyCancellable>()
    private let minRate = CustomTextField(frame: CGRect(x: 16, y: 356, width: 158, height: 34))
    private let maxRate = CustomTextField(frame: CGRect(x: 204, y: 356, width: 160, height: 34))
    
    var id: String?
    var symbol: String?
    var cryptoPrice: String?
    var priceChanges: String?
    
    internal init(cryptoManager: CryptoManager, userNotificationCenter: UNUserNotificationCenter) {
        self.cryptoManager = cryptoManager
        self.userNotificationCenter = userNotificationCenter
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.cryptoManager = CryptoManager()
        self.userNotificationCenter = UNUserNotificationCenter.current()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelViewRates.text = cryptoPrice
        print(cryptoPrice ?? "Crypto price is not here", "Crypto price")
        if let priceChangesValue = priceChanges {
            cryptoChanges.text = String(priceChangesValue)+"$"
        } else {
            cryptoChanges.text = nil
        }
        cryptoSymbol.text = symbol?.uppercased()
        print(symbol ?? "Symbol is not here", "Symbol")
        
        let centerX = view.frame.width / 2
        let detailViewWidth: CGFloat = 289
        let xCoordinate = centerX - (detailViewWidth / 2)
        let detailGradientView = AnimatedQradientView(frame: detailView.frame(forAlignmentRect: CGRect(x: xCoordinate, y: 50, width: detailViewWidth, height: 260)))
        
        view.addSubview(detailGradientView)
        detailGradientView.layer.cornerRadius = 20.0
        view.layer.cornerRadius = 20.0
        
        detailGradientView.addSubview(labelViewRates)
        detailGradientView.addSubview(cryptoSymbol)
        detailGradientView.addSubview(cryptoChanges)
        
        NSLayoutConstraint.activate([
            labelViewRates.topAnchor.constraint(equalTo: detailGradientView.topAnchor, constant: 190),
            labelViewRates.leadingAnchor.constraint(equalTo: detailGradientView.leadingAnchor, constant: 60),
            labelViewRates.widthAnchor.constraint(equalToConstant: 220),
            labelViewRates.heightAnchor.constraint(equalToConstant: 44),
            
            cryptoChanges.topAnchor.constraint(equalTo: detailGradientView.topAnchor, constant: 45),
            cryptoChanges.leadingAnchor.constraint(equalTo: detailGradientView.leadingAnchor, constant: 200),
            cryptoChanges.widthAnchor.constraint(equalToConstant: 140),
            cryptoChanges.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        minRate.placeholder = "Enter minimum rate"
        maxRate.placeholder = "Enter maximum rate"
        view.addSubview(minRate)
        view.addSubview(maxRate)
        
    }
    
    @IBAction func trackBtnPressed(_ sender: UIButton) {
        print("Track pressed")
        requestNotificationAuthorization()
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func startMonitoring(symbol: String, minRate: Double, maxRate: Double) {
        
        DispatchQueue.main.async {
            guard let minRateText = self.minRate.text, let maxRateText = self.maxRate.text else {
                return
            }
            
            guard let minRate = Double(minRateText), let maxRate = Double(maxRateText) else {
                return
            }
            
            print("Minimum Rate: \(minRate), Maximum Rate: \(maxRate)")
            
            self.cryptoManager.startFetchingWithTimer(symbol: symbol)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching price: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { cryptoPrices in
                    if let currentPrice = cryptoPrices.coin.usd {
                        print("Received price: \(currentPrice)")
                        if currentPrice <= minRate {
                            print("Min rate:", minRate)
                            print(currentPrice, "after checking the price has dropped")
                            if !self.notificationSent {
                                self.sendNotification(symbol: symbol, price: currentPrice)
                                self.notificationSent = true
                            }
                        } else if currentPrice >= maxRate {
                            print("Max rate:", maxRate)
                            print(currentPrice, "after checking the price has increased")
                            if !self.notificationSent {
                                self.sendNotification(symbol: symbol, price: currentPrice)
                                self.notificationSent = true
                            }
                        } else {
                            print("Price is the same")
                        }
                    }
                })
                .store(in: &self.subscriptions)
        }
    }
    
    func sendNotification(symbol: String, price: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Цена \(symbol) изменилась"
        content.body = "Текущая цена: \(price)$"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "price_alert", content: content, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
            self.notificationSent = true
        }
    }
    
    
    func requestNotificationAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        DispatchQueue.main.async {
                            self.startMonitoring(
                                symbol: self.id ?? "Not working",
                                minRate: Double(self.minRate.text(in: self.minRate.selectedTextRange!) ?? "") ?? 0.0,
                                maxRate: Double(self.maxRate.text(in: self.maxRate.selectedTextRange!) ?? "") ?? 0.0
                            )
                        }
                    }
                }
            case .denied:
                return
            case .authorized:
                DispatchQueue.main.async {
                    self.startMonitoring(
                        symbol: self.id ?? "Not working",
                        minRate: Double(self.minRate.text(in: self.minRate.selectedTextRange!) ?? "") ?? 0.0,
                        maxRate: Double(self.maxRate.text(in: self.maxRate.selectedTextRange!) ?? "") ?? 0.0
                    )
                }
            default:
                return
            }
        }
    }
}

