//
//  AppDelegate.swift
//  Task Manager
//
//  Created by Duilan on 06/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configuracion de la apariencia del navbar
        configureNavigationBarAppearance()
        
        return true
    }
    
    func configureNavigationBarAppearance() {
        // init an appearance
        let appearance = UINavigationBarAppearance()
        
        // Remove the border and shadow
        appearance.configureWithTransparentBackground()
        
        // Transparent Background Color
        appearance.backgroundColor = .clear
        
        // Button Items Color
        UINavigationBar.appearance().tintColor = ThemeColors.navbar
        
        // Text & Color for titles
        appearance.titleTextAttributes = [ .foregroundColor: ThemeColors.navbar ]
        
        // Text & Color for LargeTitles
        appearance.largeTitleTextAttributes = [ .foregroundColor: ThemeColors.navbar ]
        
        // Apply the appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

