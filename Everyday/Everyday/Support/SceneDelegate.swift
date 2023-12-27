//
//  SceneDelegate.swift
//  Everyday
//
//  Created by user on 28.10.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var splashPresenter: SplashPresenterDescription?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        
        splashPresenter = SplashPresenter(scene: scene)
        setupWindow(with: scene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser == nil {
            if let viewController = storyboard.instantiateViewController(withIdentifier: "WelcomeScreenVC") as? WelcomeScreenVC {
               window?.rootViewController = viewController
            }
        } else {
            if let viewController = storyboard.instantiateViewController(withIdentifier: "EDTabBarController") as? EDTabBarController {
               window?.rootViewController = viewController
            }
        }
        
        splashPresenter?.present()
        
        let delay: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.splashPresenter?.dismiss { [weak self] in
                self?.splashPresenter = nil
            }
        }
        
        checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: WelcomeScreenVC())
        } else {
            self.goToController(with: EDTabBarController())
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            let nav = UINavigationController(rootViewController: viewController)
            if viewController is EDTabBarController {
                nav.setNavigationBarHidden(true, animated: false)
            }
            nav.modalPresentationStyle = .fullScreen
            self?.window?.rootViewController = nav
        }
    }
}
