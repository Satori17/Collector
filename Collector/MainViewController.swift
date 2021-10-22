//
//  ViewController.swift
//  Collector
//
//  Created by Saba Khitaridze on 10.09.21.
//

import UIKit
import CoreData
import LocalAuthentication

class MainViewController: UIViewController {
    
    @IBOutlet weak var countBtn: UIButton!
    @IBOutlet weak var trashBarBtn: UIBarButtonItem!
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet var mainView: UIView!
    
    
    var savedNumbers: [NSManagedObject] = []
    var total = [String]()
    var sumOfNumbers = 0.0
    var comma: Character = ","
    //Authentication
    let context = LAContext()
    var error: NSError?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInterface()
        authenticateUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        //3
        do {
            savedNumbers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        
        for i in savedNumbers {
            sumOfNumbers += Double("\(i.value(forKeyPath: "name")!)".doubleValue)
        }
        
        if savedNumbers.count > 0 {
            trashBarBtn.isEnabled = true
            countBtn.isHidden = false
            mainView.backgroundColor = #colorLiteral(red: 0, green: 0.5395529866, blue: 0, alpha: 1)
        } else {
            trashBarBtn.isEnabled = false
            countBtn.isHidden = true
            mainView.backgroundColor = .systemBackground
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Number", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let textField = alert.textFields?.first,
                  let numberToSave = textField.text else {
                return
            }
            if textField.text != "" {
                self.trashBarBtn.isEnabled = true
                self.countBtn.layer.borderColor = UIColor.white.cgColor
                self.countBtn.setTitleColor(.white, for: .normal)
            } else {
                if self.sumOfNumbers < 1 {
                    self.countBtn.layer.borderColor = UIColor.clear.cgColor
                    self.countBtn.setTitleColor(.clear, for: .normal)
                }
            }
            self.countBtn.isHidden = false
            
            if textField.text?.isEmpty == false {
                if Int(numberToSave.doubleValue) % 1 == 0 {
                    self.save(name: "\(numberToSave)")
                } else {
                    self.save(name: "\(numberToSave.doubleValue)")
                }
                self.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.5395529866, blue: 0, alpha: 1)
            }
            self.numberTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField(configurationHandler: { textField in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Type Number"
            if textField.text!.count > 0 {
                saveAction.isEnabled = true
            }
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func countButtonPressed(_ sender: UIButton) {
        let mystoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = mystoryboard.instantiateViewController(withIdentifier: "TotalViewController") as! TotalViewController
        let roundedNumber = String(format: "%.0f", sumOfNumbers)
        if sumOfNumbers - Double(roundedNumber)! == 0 {
            secondVC.overall.text = "\(roundedNumber) GEL"
        } else {
            secondVC.overall.text = "\(String(format: "%.2f", sumOfNumbers)) GEL"
        }
        navigationController?.pushViewController(secondVC, animated: true)
        sumOfNumbers = 0
    }
    
    func UIInterface() {
        numberTableView.bounces = false
        countBtn.layer.cornerRadius = 20
        countBtn.layer.borderWidth = 3
        countBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    //Save to coreData
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        let number = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        // 3
        number.setValue(name, forKeyPath: "name")
        // 4
        do {
            try managedContext.save()
            savedNumbers.append(number)
            sumOfNumbers += Double("\(number.value(forKeyPath: "name")!)".doubleValue)
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    // deleting data from coreData
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        let alert = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            action in
            do {
                let numbers = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                for number in numbers {
                    managedContext.delete(number)
                }
                try managedContext.save()
            } catch {
                print(error.localizedDescription)
            }
            self.mainView.backgroundColor = .systemBackground
            self.countBtn.isHidden = true
            self.trashBarBtn.isEnabled = false
            self.sumOfNumbers = 0
            self.savedNumbers = []
            self.numberTableView.reloadData()
        }
    
        let noAction = UIAlertAction(title: "No", style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

// String Formatter to double
extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
