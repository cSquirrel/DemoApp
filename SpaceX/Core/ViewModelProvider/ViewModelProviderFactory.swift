//
//  ViewModelProviderFactory.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation

protocol ViewModelProviderFactory {
    func create() -> ViewModelProvider
}

struct MockViewModelProviderFactory: ViewModelProviderFactory {
    
    func create() -> ViewModelProvider {
        let dataSource = MockDataSource()
        let viewModelProvider = DefaultViewModelProvider(dataSource: dataSource)
        return viewModelProvider
    }
    
}
    
struct LiveViewModelProviderFactory: ViewModelProviderFactory {
    
    let urlFetcher: UrlFetcher
    let api: APIConnector
    
    func create() -> ViewModelProvider {
        
        let dataSource = RemoteDataSource(api: api)
        let viewModelProvider = DefaultViewModelProvider(dataSource: dataSource)
        
        return viewModelProvider
    }
    
}
