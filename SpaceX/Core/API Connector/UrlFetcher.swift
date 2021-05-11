//
//  UrlFetcher.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import Foundation
import Combine

protocol UrlFetcher {
    func fetch(url: URL, forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

struct HttpFetcher: UrlFetcher {
    
    private let session: URLSession
    
    init(session s: URLSession) {
        session = s
    }
    
    func fetch(url: URL, forceReload: Bool = false) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        let request = URLRequest(url: url)
        let result = session
            .dataTaskPublisher(for: request)
        return result.eraseToAnyPublisher()
    }
}

struct CachedHttpFetcher: UrlFetcher {
    
    let wrapped: HttpFetcher
    var urlCache: URLCache
    
    func fetch(url: URL, forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        let request = URLRequest(url: url)
        if forceReload == false, let cachedResponse = urlCache.cachedResponse(for: request) {
            let value = (data: cachedResponse.data, response: cachedResponse.response)
            return Just(value)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        } else {
            return wrapped.fetch(url: url, forceReload: forceReload)
        }
    }
}
