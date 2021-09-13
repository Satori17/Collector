//
//  TableViewController.swift
//  Collector
//
//  Created by Saba Khitaridze on 10.09.21.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let oneNumber = savedNumbers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell") as! numberCell
            cell.numberLabel.text = oneNumber.value(forKeyPath: "name") as? String
        
        return cell
    }
    
}
