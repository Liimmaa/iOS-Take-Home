//
//  Parser.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 18/01/2022.
//


import Foundation

protocol GetGifEvent: AnyObject {
    func getGifs(_ data: [GifObject]) -> Void
}

final class GifViewModel {
    var apiClient = GifAPIClient()
    weak var delegate: GetGifEvent?
    
    func getTrendingGif() {
        apiClient.getRequest(params: [Constants.rating: Constants.pg], gifType: Constants.trending) { [weak self] (result: APIListResponse) in
            self?.delegate?.getGifs(result.data)
        }
    }
    
    func getGifbySearch(completion: @escaping ((_ data: [GifObject]) -> Void), searchword: String) {
        apiClient.getRequest(params: [Constants.searchword : searchword], gifType: Constants.search) { [weak self] (result: APIListResponse) in
            self?.delegate?.getGifs(result.data)
        }
    }
    
    init(delegate: GetGifEvent) {
        self.delegate = delegate
    }
}
