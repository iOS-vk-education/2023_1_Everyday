//
//  EDTabBarController.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import SwiftUI

final class EDTabBarController: UITabBarController {
    
    let tabBarAppearance = UITabBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        viewControllers = [createAnalyticsNC(), createTasksNC(), createSettingsNC()]
    }
    
    func createTasksNC() -> UINavigationController {
        let tasksVC = TasksVC()
        tasksVC.title = "Tasks"
        return UINavigationController(rootViewController: tasksVC)
    }
    
    func createAnalyticsNC() -> UINavigationController {
        let analyticsVC = UIHostingController(rootView: ChartGridView())
//        analyticsVC.title = "Analytics"
//        analyticsVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
//        analyticsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        return UINavigationController(rootViewController: analyticsVC)
    }
    
    func createSettingsNC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.title = "Settings"
        return UINavigationController(rootViewController: settingsVC)
    }
}
