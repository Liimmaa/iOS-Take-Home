//
//  GetIdParser.swift
//  Dispo Take Home
//
//  Created by Chioma Amanda Mmegwa  on 19/01/2022.
//

import Foundation

protocol GetGifDetailsEvent: AnyObject {
    func getGif(_ gifDetail: GifIDResponse) -> Void
}

final class DetailViewModel {
    var apiClient = GifAPIClient()
    weak var delegate: GetGifDetailsEvent?
    
    func getDetailsById(id: String) {
        apiClient.getRequest(gifType: id) { [weak self] (result: GifIDResponse) in
            self?.delegate?.getGif(result)
        }
    }
    
    init(delegate: GetGifDetailsEvent) {
        self.delegate = delegate
    }
}
