//
//  DataSource.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import Foundation
import Combine

enum DataSourceError: Error {
    // TODO: specialised errors
    // i.e. http connectivity error, corrupted data error
    case generalError
}

protocol DataSource {
    
    func fetchCompanyInfo(forceReload: Bool) -> AnyPublisher<CompanyInfo, DataSourceError>
    
    func fetchAllLaunches(forceReload: Bool) -> AnyPublisher<[LaunchInfo], DataSourceError>
}
