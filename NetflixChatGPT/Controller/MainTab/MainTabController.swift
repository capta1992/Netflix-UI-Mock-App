//
//  MainTabController.swift
//  NetflixChatGPT
//
//  Created by Lawson Falomo on 10/9/23.
//

import UIKit

private enum Constants {
    static let homeTabBarTitle: String = "Home"
    static let homeTabBarImage: String = "doc.richtext.ko"
    static let newAndHotTabBarTitle: String = "New & Hot"
    static let newAndHotTabBarImage: String = "rectangle.stack.fill"
    static let myNetflixTabBarTitle: String = "My Netflix"
    static let myNetflixTabBarImage: String = "magnifyingglass"
}

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private let tabBarItems: [TabBarItem] = [
        TabBarItem(
            viewController: NetflixHomeViewController(),
            title: Constants.homeTabBarTitle,
            imageName: Constants.homeTabBarImage
        ),
        TabBarItem(
            viewController: NewHotViewController(),
            title: Constants.newAndHotTabBarTitle,
            imageName: Constants.newAndHotTabBarImage
        ),
        TabBarItem(
            viewController: MyNetflixViewController(),
            title: Constants.myNetflixTabBarTitle,
            imageName: Constants.myNetflixTabBarImage
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1.0)
        
        viewControllers = tabBarItems.map {
            createNavController(
                with: $0.viewController,
                title: $0.title,
                imageName: $0.imageName
            )
        }
        // Adjusting the color to more closely match the image
           tabBar.barTintColor = UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1.0) // Fine-tuned color
           tabBar.tintColor = .white
           tabBar.isTranslucent = false
           tabBar.unselectedItemTintColor = UIColor.gray
    }
    
    private func createNavController(with rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        rootViewController.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
}
