//
//  UIColor+Ext.swift
//  Task Manager
//
//  Created by Duilan on 01/11/21.
//

import UIKit

extension UIColor {
    func darker() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.1, 0.0), green: max(g - 0.1, 0.0), blue: max(b - 0.1, 0.0), alpha: a)
        }
        return UIColor()
    }
    
    func lighter() -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        // more green to make it more light diff tone
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.35, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        return UIColor()
    }
}
