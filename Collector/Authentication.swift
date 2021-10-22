//
//  Authentication.swift
//  Collector
//
//  Created by Saba Khitaridze on 21.10.21.



import UIKit
import LocalAuthentication

extension MainViewController {
    
    func authenticateUser() {
        //if biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        //failed
                        let alert = UIAlertController(title: "Authentication Failed", message: "Please Try Again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        return
                    }
                    //Success
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
//        else {
//            // if not possible
//            let alert = UIAlertController(title: "Face ID is Disabled", message: "You can't use this feature", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Activate Face ID", style: .default, handler: { action in
//                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(settingsUrl)
//                }
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
    }
}
