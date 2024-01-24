//
//  CryptoTableViewCell.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 06.07.23.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var cryptoCode: UILabel!
    @IBOutlet weak var cryptoRate: UILabel!
    @IBOutlet weak var precentageChanges: UILabel!
    
    
    static let identifier = "CryptoTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CryptoTableViewCell", bundle: nil)
    }
    
    func checking(precentageValue: Double) {
        if precentageValue < 0.0 {
            precentageChanges.textColor = UIColor(red: 251/255, green: 58/255, blue: 48/255, alpha: 1.0)
        } else {
            precentageChanges.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
            precentageChanges.text = "+\(precentageValue)"
            return
        }
        precentageChanges.text = String(precentageValue)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
