//
//  RemoteImage.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 06/05/2021.
//

import SwiftUI
import Combine

enum ImageLoadState {
    case loading
    case success(Data)
    case failure
}

class RemoteImageLoader: ObservableObject {

    var state = ImageLoadState.loading
    private var bag = Array<AnyCancellable>()
    private let urlFetcher: UrlFetcher
    
    init(imageData: Data, urlFetcher uf: UrlFetcher) {
        state = .success(imageData)
        urlFetcher = uf
    }
    
    init(url: URL?, urlFetcher uf: UrlFetcher) {

        urlFetcher = uf
        
        guard let imageUrl = url else {
            self.state = .failure
            return
        }
        
        let imageData = 
            urlFetcher.fetch(url: imageUrl, forceReload: false)
            .map { $0.data }
            .map({ data in
                if data.count > 0 {
                    return ImageLoadState.success(data)
                } else {
                    return ImageLoadState.failure
                }
            })
            .catch({ _ in
                return Just(ImageLoadState.failure)
            })
            .share()
            
        imageData
            .assign(to: \.state, on: self)
            .store(in: &bag)
        
        imageData
            .sink { _ in
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
            .store(in: &bag)
        
    }
}
