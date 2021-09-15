//
//  TotalViewController.swift
//  Collector
//
//  Created by Saba Khitaridze on 11.09.21.
//

import UIKit

class TotalViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    
    let firstVC = MainViewController()
    let overall = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = overall.text
    }
}

