//
//  CharactersVC.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 20-04-22.
//

import UIKit

class CharactersVC: UIViewController {
    
    var rmViewModel = RMListViewModel()
    let actitvityindicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addActivityindicator()
        getCharacters()
        stateManager()
    }
}

private extension CharactersVC {
    func getCharacters()  {
        Task {
            await rmViewModel.getCharacters()
        }
    }
    func stateManager()  {
        rmViewModel.refreshRMViewModel = { [weak self] stateIn in
            switch stateIn {
            case .loaded(let characters):
                self?.actitvityindicator.stopAnimating()
                print(characters)
            case .loading:
                self?.actitvityindicator.startAnimating()
                print("Estoy cargando")
            case .loadedWithError(let error):
                print(error.rawValue)
                
            }
            
        }
    }
    
    func addActivityindicator()  {
        view.addSubview(actitvityindicator)
        actitvityindicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actitvityindicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actitvityindicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
