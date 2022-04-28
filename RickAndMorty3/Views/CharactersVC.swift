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
    var dataSource          : UICollectionViewDiffableDataSource<Constants.Section,RMModel>?
    var filteredCharacters  : [RMModel] = []
    var characters          : [RMModel] = []
    var hasMoreCharacters   = true
    var isSearching         = false
    var isLoading           = false
    var page                = 1
    let actitvityindicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    init(rmViewModel : RMListViewModel) {
        self.rmViewModel = rmViewModel
        super.init(nibName: nil, bundle: nil)
        addActivityindicator()
        getCharacters(page: page)
        stateManager()
        configSearchController()
        configCollection()
        configDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
    func getCharacters(page: Int)  {
        Task {
            await rmViewModel?.getCharacters(page: page)
        }
    }
    func stateManager()  {
        rmViewModel?.refreshRMViewModel = { [weak self] stateIn in
            switch stateIn {
            case .loaded(let characters):
                self?.actitvityindicator.stopAnimating()
                self?.characters.append(contentsOf: characters)
                self?.updateDataSource(on: self?.characters ?? [])
            case .loading:
                self?.actitvityindicator.startAnimating()
            case .loadedWithError(let error):
                print(error.rawValue)
            }
            
        }
    }
    
    func addActivityindicator()  {
        view.addSubViews(actitvityindicator)
        NSLayoutConstraint.activate([
            actitvityindicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actitvityindicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

private extension CharactersVC {
    func configCollection()  {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createLayout())
        view.addSubViews(collectionView)
        view.sendSubviewToBack(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RMCharCell.self, forCellWithReuseIdentifier: RMCharCell.reuseID)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configDataSource()  {
        dataSource = UICollectionViewDiffableDataSource<Constants.Section,RMModel>(collectionView: collectionView, cellProvider: {(collectionView, indexPath, character) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharCell.reuseID, for: indexPath) as? RMCharCell
            guard let strongCell = cell else { return UICollectionViewCell() }
            strongCell.setCharCell(rmModel: character)
            return strongCell
            
        })
        collectionView.dataSource = dataSource
    }
    func updateDataSource(on characters: [RMModel])  {
        var snapshot = NSDiffableDataSourceSnapshot<Constants.Section,RMModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        
    }
}
extension CharactersVC : UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            filteredCharacters.removeAll()
            updateDataSource(on: characters)
            return
        }
        isSearching = true
        filteredCharacters = characters.filter { charRm -> Bool in
            return charRm.name.lowercased().contains(filter)
        }
        guard filteredCharacters.count != 0 else {
            self.showAlertOnMainThread(title: "OOPS!!!", message: "No character named \(filter) was found, try again")
            return
        }
        updateDataSource(on: filteredCharacters)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateDataSource(on: characters)
    }
}


extension CharactersVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            page += 1
            getCharacters(page: page)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else { return false }
        
        // Allows for closing an already open cell
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        
        dataSource.refresh()
        
        return false // The selecting or deselecting is already performed above
    }
}

extension UICollectionViewDiffableDataSource {
    /// Reapplies the current snapshot to the data source, animating the differences.
    /// - Parameters:
    ///   - completion: A closure to be called on completion of reapplying the snapshot.
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}
