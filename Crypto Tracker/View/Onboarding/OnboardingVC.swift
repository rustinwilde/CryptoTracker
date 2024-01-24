//
//  OnboardingVC.swift
//  Crypto Tracker
//
//  Created by Rustin Wilde on 05.07.23.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingSubtitle: UILabel!
    @IBOutlet weak var onboardingBtn: UIButton!
    let button = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animatedGradientView = AnimatedQradientView(frame: view.bounds)
        view.insertSubview(animatedGradientView, belowSubview: onboardingTitle)
        
    }
    
    
    
    
}
