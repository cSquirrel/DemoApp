//
//  RemoteImage.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 06/05/2021.
//

import SwiftUI
import Combine

class RemoteImageManager: ObservableObject {
    
    private let urlFetcher: UrlFetcher
    
    init(urlFetcher uf: UrlFetcher) {
        urlFetcher = uf
    }
    
    func fetchImage(url: URL?) -> RemoteImageLoader {
        return RemoteImageLoader(url: url, urlFetcher: urlFetcher)
    }
    
}
