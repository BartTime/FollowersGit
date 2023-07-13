//
//  GFTabBarController.swift
//  GitHubFollowers
//
//  Created by Alex on 12.03.2022.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor  = .green
        viewControllers                  = [createSearchNC(), createFavoriteNC()]
    }
    
    func createSearchNC() -> UINavigationController{
        let searchVC        = SearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavoriteNC() -> UINavigationController{
        let favoritesListVC        = FavoriteListVC()
        favoritesListVC.title      = "Favorites"
        favoritesListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
    
    
}
