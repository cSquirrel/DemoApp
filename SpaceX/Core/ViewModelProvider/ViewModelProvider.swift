//
//  ViewModelProvider.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
import Combine

enum ContentState<T> {
    case fetching
    case loaded(T)
    case empty
    case error(DataSourceError)
}

protocol ViewModelProvider {
    
    func fetchCompanyInfo(forceReload: Bool) -> AnyPublisher<ContentState<String>, Never>
    
    func fetchAllLaunches(criteria: FilterCriteria, order: ComparisonResult, forceReload: Bool) -> AnyPublisher<ContentState<[LaunchModel]>, Never>
    
}
