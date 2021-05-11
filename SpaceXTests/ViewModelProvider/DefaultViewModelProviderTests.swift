//
//  DefaultViewModelProviderTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 10/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

class DefaultViewModelProviderTests: XCTestCase {

    var bag = Array<AnyCancellable>()
    
    func testFetchCompanyInfo() throws {
        
        let expectation = expectation(description: "Returns value")
        let dataSource: DataSource = MockDataSource()
        let provider = DefaultViewModelProvider(dataSource: dataSource)
        
        provider
            .fetchCompanyInfo()
            .sink { (value: ContentState<String>) in
                expectation.fulfill()
            }
            .store(in: &bag)
            
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchAllLaunches() throws {
        
        let expectation = expectation(description: "Returns value")
        let dataSource: DataSource = MockDataSource()
        let provider = DefaultViewModelProvider(dataSource: dataSource)
        
        provider
            .fetchAllLaunches(order: .orderedAscending)
            .sink { (value: ContentState<[LaunchModel]>) in
                expectation.fulfill()
            }
            .store(in: &bag)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
