//
//  ViewController+Ext.swift
//  Task Manager
//
//  Created by Duilan on 17/10/21.
//

import UIKit

extension UIViewController {
    // Añade Child Viewcontroller en el VC actual
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

// Extension para que TMAlertVC sea accesible desde los VC
extension UIViewController {
    func presentTMAlertVC(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = TMAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
}
