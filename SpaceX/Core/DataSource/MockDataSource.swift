//
//  MockDataSource.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
import Combine

private class BundleProvider {}

func LoadJsonData(fileName: String) throws -> Data {
    let bundle = Bundle(for: BundleProvider.self)
    let contentUrl = bundle.url(forResource: fileName, withExtension: nil)!
    let result = try Data(contentsOf: contentUrl)
    return result
}

struct MockDataSource {}

extension MockDataSource: DataSource {
    
    func fetchCompanyInfo(forceReload: Bool = false) -> AnyPublisher<CompanyInfo, DataSourceError> {
        
        do {
            let companyInfoJson = try LoadJsonData(fileName: "MockCompanyInfo.json")
            let companyInfo = try JSONDecoder().decode(CompanyInfo.self, from: companyInfoJson)
            return Just(companyInfo)
                .setFailureType(to: DataSourceError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DataSourceError.generalError)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchAllLaunches(forceReload: Bool = false) -> AnyPublisher<[LaunchInfo], DataSourceError> {
        
        do {
            let allLaunchesJson = try LoadJsonData(fileName: "MockAllLaunches.json")
            let allLaunches = try JSONDecoder().decode([LaunchInfo].self, from: allLaunchesJson)
            
            return Just(allLaunches)
                .setFailureType(to: DataSourceError.self)
//                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DataSourceError.generalError)
                .eraseToAnyPublisher()
        }
    }
    
    
}

