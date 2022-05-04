//
//  RMListViewModel.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 20-04-22.
//

import Foundation
enum RMViemodelState: Equatable {
    static func == (lhs: RMViemodelState, rhs: RMViemodelState) -> Bool {
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
    
    case loaded(model: [RMModel])
    case loading
    case loadedWithError(error: RMErrors)
}

@MainActor
class RMListViewModel {
    var characters = [RMModel]()
    var state : RMViemodelState = .loading {
        didSet {
            refreshRMViewModel?(state)
        }
    }
    var refreshRMViewModel : ((RMViemodelState) -> Void)?
    
    func getCharacters(page: Int) async {
        do {
            state = .loading
            let characters = try await RMServices.shared.getAllCharacters(page: page)
            self.characters = characters.map(RMModel.init)
            state = .loaded(model: self.characters)
        } catch {
            state = .loadedWithError(error: .invalidData)
            print(error)
        }
    }
     func connectCallback(callback: @escaping (RMViemodelState) -> ()) {
         self.refreshRMViewModel = callback
    }
}

struct RMModel {
    fileprivate let rmCharacter : Character
    var id : Int {
        rmCharacter.id
    }
    var name : String {
        rmCharacter.name
    }
    var status : String {
        rmCharacter.status
    }
    var species : String {
        rmCharacter.species
    }
    var gender : String {
        rmCharacter.gender
    }
    var image : String {
        rmCharacter.image
    }
}
extension RMModel: Hashable {
    static func == (lhs: RMModel, rhs: RMModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
