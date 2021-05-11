//
//  APIConnector.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
import Combine


struct APIConnectorConfiguration: Decodable {
    
    let companyInfoEndpoint: URL
    
    let allLaunchesEndpoint: URL
}

protocol APIConnector {
    
    func fetchCompanyInfo(forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
    func fetchAllLaunches(forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
}

struct DefaultAPIConnector {
    
    let configuration: APIConnectorConfiguration
    let urlFetcher: UrlFetcher
    
}

extension DefaultAPIConnector: APIConnector {
    
    func fetchCompanyInfo(forceReload: Bool = false) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let url = configuration.companyInfoEndpoint
        return urlFetcher.fetch(url: url, forceReload: forceReload).eraseToAnyPublisher()
    }
    
    func fetchAllLaunches(forceReload: Bool = false) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let url = configuration.allLaunchesEndpoint
        return urlFetcher.fetch(url: url, forceReload: forceReload).eraseToAnyPublisher()
    }
    
}
