//
//  RMTabController.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 20-04-22.
//

import UIKit

class RMTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .black
        viewControllers = [charactersNC()]
    }

}

private extension RMTabController {
    func charactersNC() -> UINavigationController {
        let viewModel = RMListViewModel()
        let character = CharactersVC(rmViewModel: viewModel)
        character.title = "Characters"
        character.tabBarItem = UITabBarItem(title: "Characters", image: Constants.RMSystemSymbols.characters, tag: 0)
        return UINavigationController(rootViewController: character)
    }
}
