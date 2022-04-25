//
//  CharactersVC.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 20-04-22.
//

import UIKit

class CharactersVC: UIViewController {
    
    var rmViewModel : RMListViewModel?
    var collectionView      : UICollectionView!
    var dataSource          : UICollectionViewDiffableDataSource<Constants.Section,Character>!
    var filteredCharacters  : [RMModel] = []
    var characters          : [RMModel] = []
    var hasMoreCharacters   = true
    var isSearching         = false
    var isLoading           = false
    
    init(rmViewModel : RMListViewModel) {
        self.rmViewModel = rmViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let actitvityindicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addActivityindicator()
        getCharacters()
        stateManager()
        configSearchController()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

private extension CharactersVC {
    func configSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    func getCharacters()  {
        Task {
            await rmViewModel?.getCharacters()
        }
    }
    func stateManager()  {
        rmViewModel?.refreshRMViewModel = { [weak self] stateIn in
            switch stateIn {
            case .loaded(let characters):
                self?.actitvityindicator.stopAnimating()
                self?.characters.append(contentsOf: characters)
                self?.showAlertOnMainThread(title: "Prueba", message: "Mensaje de saludos")
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

extension CharactersVC : UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
