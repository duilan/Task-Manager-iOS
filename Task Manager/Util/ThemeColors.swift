//
//  ThemeColors.swift
//  Task Manager
//
//  Created by Duilan on 12/10/21.
//

import UIKit

struct ThemeColors {
    static let backgroundPrimary = UIColor(named: "BackgroundPrimary") ?? .systemBackground
    static let accentColor = UIColor(named: "AccentColor") ?? .gray
    
    // Title && Text Colors
    static let title = UIColor(named: "Title") ?? .gray
    static let titleInverted = UIColor(named: "TitleInverted") ?? .gray
    
    static let subtitle = UIColor(named: "Subtitle") ?? .gray
    
    static let text = UIColor(named: "Text") ?? .gray
    static let textInverted = UIColor(named: "TextInverted") ?? .gray
    static let textDisabled = UIColor(named: "TextDisabled") ?? .gray
    
    static let navbar = UIColor(named: "Navbar") ?? .gray
    
    static let checked = UIColor(named: "Checked") ?? .gray
    static let unchecked = UIColor(named: "Unchecked") ?? .gray
    
    // genera una layer con gradiente
    static func createGradientLayer(colorSet: [UIColor], startAndEndPoints: (CGPoint, CGPoint)? = nil) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorSet.map { $0.cgColor }
        
        if let points = startAndEndPoints {
            gradientLayer.startPoint = points.0
            gradientLayer.endPoint = points.1
        }
        return gradientLayer
    }
}

