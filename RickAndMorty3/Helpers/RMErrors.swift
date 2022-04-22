//
//  RMErrors.swift
//  RickAndMorty
//
//  Created by Felix Alexander Sotelo Quezada on 30-03-21.
//

import Foundation

enum RMErrors: String, Error {
    case invalidUsername    = "This username created an invalid request. Please try again"
    case unableToComplete   = "Unable to complete your request"
    case invalidResponse    = "Invalid Response from the server"
    case invalidData        = "Data invalid from server"
    case unableToFavorito   = "There was an error in favorites"
    case existsInFavorite   = "The data already exist in favorites"}
