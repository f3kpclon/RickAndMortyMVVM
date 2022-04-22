//
//  RMServices.swift
//  RickAndMorty3
//
//  Created by Felix Alexander Sotelo Quezada on 20-04-22.
//

import Foundation
import UIKit

class RMServices {
    let cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()
    static let shared          = RMServices()
    
    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getAllCharacters() async throws -> [Character] {
        let page = Int.random(in: 1...20)
        let url = Constants.RMUrl.apiUrl + "/character?page=\(page)"
        guard let apiUrl = URL(string: url) else { throw RMErrors.unableToComplete }
        
        async let (charData, response) = URLSession.shared.data(from: apiUrl)
        
        guard let response = try await response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RMErrors.unableToComplete
        }
        guard let char = try? decoder.decode(ListOfCharacters.self, from: try await charData) else {
            throw RMErrors.invalidData
        }
        return char.results
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            async let (data, _) = URLSession.shared.data(from: url)
            guard let image = UIImage(data: try await data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
