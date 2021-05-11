//
//  RemoteDataSource.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
import Combine

struct RemoteDataSource {
    
    let api: APIConnector
}

extension RemoteDataSource: DataSource {
    
    func fetchCompanyInfo(forceReload: Bool = false) -> AnyPublisher<CompanyInfo, DataSourceError> {

        let cancellable = api
            .fetchCompanyInfo(forceReload: forceReload)
            .handleResponse()
            .decode(type: CompanyInfo.self, decoder: JSONDecoder())
            .mapError { _ -> DataSourceError in
                return .generalError
            }
            .eraseToAnyPublisher()
        return cancellable
        
    }
    
    func fetchAllLaunches(forceReload: Bool = false) -> AnyPublisher<[LaunchInfo], DataSourceError> {
        
        let cancellable = api
            .fetchAllLaunches(forceReload: forceReload)
            .handleResponse()
            .decode(type: [LaunchInfo].self, decoder: JSONDecoder())
            .mapError { err -> DataSourceError in
                return .generalError
            }
            .eraseToAnyPublisher()
        return cancellable
    }
}

extension Publisher where Output == (data: Data, response: URLResponse), Failure == URLError {
    
    func handleResponse() -> AnyPublisher<Data, Error> {
        return self
            .tryMap({ (data: Data, response: URLResponse) in
                if let http = response as? HTTPURLResponse {
                    switch http.statusCode {
                    case 200..<299:
                        return data
                    default:
                        throw DataSourceError.generalError
                    }
                } else {
                    return data
                }
            })
            .eraseToAnyPublisher()
    }
}
