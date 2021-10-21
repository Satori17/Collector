//
//  TableViewController.swift
//  Collector
//
//  Created by Saba Khitaridze on 10.09.21.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Remove function with swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currentNumber = savedNumbers[indexPath.row]
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(currentNumber)
            self.savedNumbers.remove(at: indexPath.row)
            sumOfNumbers -= Double("\(currentNumber.value(forKeyPath: "name")!)".doubleValue)
            self.numberTableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try managedContext.save()
            } catch {
                print("Could not remove \(error)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.savedNumbers.count > 0 {
                    self.trashBarBtn.isEnabled = true
                    self.countBtn.isHidden = false
                    self.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.5395529866, blue: 0, alpha: 1)
                } else {
                    self.trashBarBtn.isEnabled = false
                    self.countBtn.isHidden = true
                    self.mainView.backgroundColor = .systemBackground
                }
            }
        }
    }
}
