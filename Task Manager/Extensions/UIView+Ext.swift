//
//  UIView+Ext.swift
//  Task Manager
//
//  Created by Duilan on 19/10/21.
//

import UIKit

extension UIView {
    
    func addGradientBackground(colorSet: [UIColor], startAndEndPoints: (CGPoint, CGPoint)? = nil){
        
        //elimina gradient si existe previamente
        self.removeGradientLayerBackground()
        
        self.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorSet.map { $0.cgColor }
        gradientLayer.frame = self.bounds
        gradientLayer.name = "GradientLayerBackground"
        
        if let points = startAndEndPoints {
            gradientLayer.startPoint = points.0
            gradientLayer.endPoint = points.1
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientLayerBackground() {
        for item in self.layer.sublayers ?? [] where item.name == "GradientLayerBackground" {
            item.removeFromSuperlayer()
        }
    }
    
}

