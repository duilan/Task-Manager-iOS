//
//  ViewController+Ext.swift
//  Task Manager
//
//  Created by Duilan on 17/10/21.
//

import UIKit

extension UIViewController {
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
