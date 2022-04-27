//
//  RMCharCell.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 26-04-22.
//

import UIKit

class RMCharCell: UICollectionViewCell {
    static let reuseID = "RMCharCell"
    var rmCellViewModel = RMCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .systemMint
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setCharCell(rmModel: RMModel) {
        charBindingManager()
        Task {
            await rmCellViewModel.getCellData(url: rmModel.image, rmModel: rmModel)
        }
    }
    
    func charBindingManager()  {
        rmCellViewModel.refreshRMCellViewModel = {  stateIn in
            switch stateIn {
            case .loaded(let char):
                print("PERSONAJE: \(char)")
            case .loading:
                print("CARGANDO...")
            case .loadedWithError(let error):
                print(error.rawValue)
            }
            
        }
    }
}
