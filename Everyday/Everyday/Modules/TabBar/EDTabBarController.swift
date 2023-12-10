//
//  EDTabBarController.swift
//  Everyday
//
//  Created by user on 31.10.2023.
//

import UIKit
import SwiftUI

final class EDTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.brandSecondary
        viewControllers = [createAnalyticsNC(), createTasksNC(), createSettingsNC()]
        selectedIndex = 1
    }
    
    func createTasksNC() -> UINavigationController {
        let tasksVC = TasksVC()
        tasksVC.tabBarItem.image = UIImage(systemName: "list.bullet")
        tasksVC.tabBarItem.image?.withTintColor(.brandSecondary)
        return UINavigationController(rootViewController: tasksVC)
    }
    
    func createAnalyticsNC() -> UINavigationController {
        let analyticsVC = UIHostingController(rootView: ChartGridView())
        analyticsVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill")
        analyticsVC.tabBarItem.image?.withTintColor(.brandSecondary)
        let analyticsNC = UINavigationController(rootViewController: analyticsVC)
        analyticsNC.setNavigationBarHidden(true, animated: false)
        return analyticsNC
    }
    
    func createSettingsNC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem.image = UIImage(systemName: "gear")
        return UINavigationController(rootViewController: settingsVC)
    }
}
