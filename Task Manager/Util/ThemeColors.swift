//
//  ThemeColors.swift
//  Task Manager
//
//  Created by Duilan on 12/10/21.
//

import UIKit

struct ThemeColors {
    static let backgroundPrimary = UIColor(named: "BackgroundPrimary") ?? .systemBackground
    
    // Title && Text Colors
    static let title = UIColor(named: "Title") ?? .gray
    static let titleInverted = UIColor(named: "TitleInverted") ?? .gray
    
    static let subtitle = UIColor(named: "Subtitle") ?? .gray
    
    static let text = UIColor(named: "Text") ?? .gray
    static let textInverted = UIColor(named: "TextInverted") ?? .gray
    static let textDisabled = UIColor(named: "TextDisabled") ?? .gray
    
    static let navbar = UIColor(named: "Navbar") ?? .gray
    
    static let green = UIColor(named: "Green") ?? .gray
    
    static let blueLight = UIColor(named: "GradientBlueLight") ?? .gray
    static let blueDark = UIColor(named: "GradientBlueDark") ?? .gray
    
    static let accentColor = UIColor(named: "AccentColor") ?? .gray
    
}

