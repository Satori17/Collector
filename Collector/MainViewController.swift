//
//  ViewController.swift
//  Collector
//
//  Created by Saba Khitaridze on 10.09.21.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var countBtn: UIButton!
    @IBOutlet weak var trashBarBtn: UIBarButtonItem!
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet var mainView: UIView!
    
   
    var savedNumbers: [NSManagedObject] = []
    var total = [String]()
    var sumOfNumbers = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInterface()
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
            sumOfNumbers += Double("\(i.value(forKeyPath: "name")!)") ?? 0
        }
        
        if savedNumbers.count > 0 {
            trashBarBtn.isEnabled = true
            countBtn.isHidden = false
            mainView.backgroundColor = #colorLiteral(red: 0, green: 0.5515218377, blue: 0, alpha: 1)
            
        } else {
            trashBarBtn.isEnabled = false
            countBtn.isHidden = true
            mainView.backgroundColor = .systemBackground
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "დაამატე რიცხვი", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "დამატება", style: .default) { action in
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
                self.save(name: numberToSave)
                self.mainView.backgroundColor = #colorLiteral(red: 0, green: 0.5515218377, blue: 0, alpha: 1)
            }
            self.numberTableView.reloadData()
        }
        
        
        let cancelAction = UIAlertAction(title: "წაშლა", style: .cancel)
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
        secondVC.overall.text = "\(sumOfNumbers) GEL"
        navigationController?.pushViewController(secondVC, animated: true)
        sumOfNumbers = 0
    }
    
    func UIInterface() {
        numberTableView.bounces = false
        countBtn.layer.cornerRadius = 20
        countBtn.layer.borderWidth = 2
        countBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func save(name: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        let number = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        // 3
        number.setValue(name, forKeyPath: "name")
        // 4
        do {
            try managedContext.save()
            savedNumbers.append(number)
            sumOfNumbers += Double("\(number.value(forKeyPath: "name")!)") ?? 0
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        let alert = UIAlertController(title: nil, message: "ნამდვილად გსურს წაშლა?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "კი", style: .default) {
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
        let noAction = UIAlertAction(title: "არა", style: .cancel)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
}

