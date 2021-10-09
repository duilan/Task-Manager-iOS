//
//  SceneDelegate.swift
//  Task Manager
//
//  Created by Duilan on 06/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = createHomeNC()
        window?.makeKeyAndVisible()
    }
    
    func createHomeNC() -> UINavigationController {
        let homeVC = HomeVC()
        return UINavigationController(rootViewController: homeVC)
    }
    
}

