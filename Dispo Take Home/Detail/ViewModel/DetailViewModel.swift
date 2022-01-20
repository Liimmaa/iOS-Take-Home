//
//  GetIdParser.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 19/01/2022.
//

import Foundation

final class DetailViewModel {
    
    func getDetailsById(completion: @escaping ((_ data: GifIDResponse) -> Void), id: String) {
        let urlString = "https://api.giphy.com/v1/gifs/\(id)?api_key=iERXBlD2YDoyY6bedNw94zDpJfE4m6X6"
        guard let api = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: api) {
            data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let result = try JSONDecoder().decode(GifIDResponse.self, from: data!)
                completion(result)
            } catch {
                
            }
        }.resume()
    }
}
