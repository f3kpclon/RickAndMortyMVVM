//
//  RMCellViewModel.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 27-04-22.
//

import Foundation
import UIKit

enum RMCellViewModelState: Equatable {
    static func == (lhs: RMCellViewModelState, rhs: RMCellViewModelState) -> Bool {
        switch (lhs, rhs) {
            case(.loading, .loading):
              return true
            case (.loaded(_),  .loaded(_)),
              (.loadedWithError(_), .loadedWithError(_)):
              return true
            default:
             return false
            }
    }
    
    case loaded(model: RMCellModel)
    case loading
    case loadedWithError(error: RMErrors)
}

@MainActor
class RMCellViewModel {
    
    var charCell : RMCellModel?
    var state : RMCellViewModelState = .loading {
        didSet {
            refreshRMCellViewModel?(state)
        }
    }
    var refreshRMCellViewModel : ((RMCellViewModelState) -> Void)?
    
    func getCellData(url: String, rmModel: RMModel) async {
        do {
            state = .loading
            let image = try await RMServices.shared.downloadImage(from: url)
            guard let image = image else {
                state = .loadedWithError(error: .invalidResponse)
                return
            }
            self.charCell = RMCellModel(rmCellChar: RMCharCellModel.init(id: rmModel.id,
                                                                     name: rmModel.name,
                                                                     status: rmModel.status,
                                                                     species: rmModel.species,
                                                                     gender: rmModel.gender,
                                                                     image: image))
            guard let charCell = charCell else {
                state = .loadedWithError(error: .invalidData)
                return
            }
            state = .loaded(model: charCell)
        } catch {
            state = .loadedWithError(error: .invalidData)
            print(error)
        }
    }
}

struct RMCellModel {
    fileprivate let rmCellChar : RMCharCellModel
    var id : Int {
        rmCellChar.id ?? 0
    }
    var name : String {
        rmCellChar.name ?? ""
    }
    var status : String {
        rmCellChar.status ?? ""
    }
    var species : String {
        rmCellChar.species ?? ""
    }
    var gender : String {
        rmCellChar.gender ?? ""
    }
    var image : UIImage? {
        rmCellChar.image
    }
}
