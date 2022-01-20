//
//  Parser.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 18/01/2022.
//

// pass through protocols


import Foundation
import UIKit

class GifViewModel {
    
    func getTrendingGif(completion: @escaping ((_ data: APIListResponse) -> Void)) {
        let string = "https://api.giphy.com/v1/gifs/trending?api_key=\(Constants.giphyApiKey)&limit=50&rating=g"
        guard let api = URL(string: string) else {return}
        
        URLSession.shared.dataTask(with: api) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let result = try JSONDecoder().decode(APIListResponse.self, from: data!)
                completion(result)
            } catch {
                
            }
        }.resume()
    }
    
    func getGifbySearch(completion: @escaping ((_ data: APIListResponse) -> Void), searchword: String) {
        let urlString = "https://api.giphy.com/v1/gifs/search?api_key=\(Constants.giphyApiKey)&q=\(searchword)&limit=50&offset=0&rating=g&lang=en"
        guard let api = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: api) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let result = try JSONDecoder().decode(APIListResponse
                                                        .self, from: data!)
                completion(result)
            } catch {
                
            }
        }.resume()
    }
}

