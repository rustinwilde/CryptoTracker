//
//  ViewController.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 05.07.23.
//

import UIKit
import Kingfisher


class HomeVCController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uiViewAssets: UIView!
    @IBOutlet weak var uiViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var viewAssetsConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var cryptoList = [CryptoData]()
    
    var animatedBackgroundGradient = AnimatedQradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.dataSource = self
        tableview.delegate = self
        
        animatedBackgroundGradient = AnimatedQradientView(frame: view.bounds)
        view.insertSubview(animatedBackgroundGradient, belowSubview: view)
        view.sendSubviewToBack(animatedBackgroundGradient)
        showAllButton.titleLabel?.textColor = .white
        
        tableview.register(CryptoTableViewCell.nib(), forCellReuseIdentifier: CryptoTableViewCell.identifier)
        self.tableview.backgroundColor = .white
        
        let anonymousFunction = { (fetchedCryptoList: [CryptoData]) in
            DispatchQueue.main.async {
                self.cryptoList = fetchedCryptoList
                self.tableview.reloadData()
            }
            
        }
        CryptoManager.shared.fetchCryptoData(onCompletion: anonymousFunction)
        
        tableview.tableFooterView = UIView()
        
    }
    
    @IBAction func showAllButtonTapped(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.clipsToBounds = true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails", let destination = segue.destination as? CryptoDetailsVC {
            destination.cryptoPrice = self.cryptoList[self.tableview.indexPathForSelectedRow!.row].cryptoPriceString
            destination.id = self.cryptoList[self.tableview.indexPathForSelectedRow!.row].id
            destination.symbol = self.cryptoList[self.tableview.indexPathForSelectedRow!.row].symbol
            destination.priceChanges = String(self.cryptoList[self.tableview.indexPathForSelectedRow!.row].price_change_percentage_24h ?? 0.0)
            print(cryptoList[tableview.indexPathForSelectedRow!.row].cryptoPriceString )
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as! CryptoTableViewCell
        cell.cryptoCode.text = cryptoList[indexPath.row].id
        cell.cryptoName.text = cryptoList[indexPath.row].name
        cell.cryptoRate.text = "\(cryptoList[indexPath.row].cryptoPriceString)"
        if let imgUrl = URL(string: cryptoList[indexPath.row].image ?? "") {
            cell.cryptoImage.kf.setImage(with: imgUrl)
        }
        
        if let percentageValue = cryptoList[indexPath.row].price_change_percentage_24h {
            cell.checking(precentageValue: percentageValue)
        } else {
            print("Warning: price_change_percentage_24h is nil for indexPath.row \(indexPath.row)")
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

