//
//  MainViewStateTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 10/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

class MainViewStateOperatorsTests: XCTestCase {
    
    private var bag = Array<AnyCancellable>()
    
    func testCannotFilterDataWhenEmptyContent() {
        
        // prepare
        let expectation = expectation(description: "Should not let filter when empty data")
        let value: ContentState<[LaunchModel]> = .empty
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        
        // execute
        state
            .canFilterData()
            .sink { flag in
                XCTAssertFalse(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCannotFilterDataWhenError() {
        
        // prepare
        let expectation = expectation(description: "Should not let filter when error")
        let value: ContentState<[LaunchModel]> = .error(.generalError)
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        
        // execute
        state
            .canFilterData()
            .sink { flag in
                XCTAssertFalse(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCannotFilterDataWhenFetching() {
        
        // prepare
        let expectation = expectation(description: "Should not let filter when fetching")
        let value: ContentState<[LaunchModel]> = .fetching
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        
        // execute
        state
            .canFilterData()
            .sink { flag in
                XCTAssertFalse(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCanFilterDataWhenLoaded() {
        
        // prepare
        let expectation = expectation(description: "Should let filter when loaded")
        let value: ContentState<[LaunchModel]> = .loaded([LaunchModel]())
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        
        // execute
        state
            .canFilterData()
            .sink { flag in
                XCTAssertTrue(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCanRefreshDataWhenConnected() {
        // prepare
        let expectation = expectation(description: "Should let refresh when connected")
        let value: ContentState<[LaunchModel]> = .loaded([LaunchModel]())
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        let networkStatus = CurrentValueSubject<NetworkStatus, Never>(.connected).eraseToAnyPublisher()
        
        // execute
        state
            .canRefreshData(networkStatus: networkStatus)
            .sink { flag in
                XCTAssertTrue(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCannotRefreshDataWhenConnected() {
        // prepare
        let expectation = expectation(description: "Should not let refresh when no network")
        let value: ContentState<[LaunchModel]> = .loaded([LaunchModel]())
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        let networkStatus = CurrentValueSubject<NetworkStatus, Never>(.noNetwork).eraseToAnyPublisher()
        
        // execute
        state
            .canRefreshData(networkStatus: networkStatus)
            .sink { flag in
                XCTAssertFalse(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCannotRefreshDataWhenFetching() {
        // prepare
        let expectation = expectation(description: "Should not let refresh when fetching data")
        let value: ContentState<[LaunchModel]> = .fetching
        let state = CurrentValueSubject<ContentState<[LaunchModel]>, Never>(value)
        let networkStatus = CurrentValueSubject<NetworkStatus, Never>(.connected).eraseToAnyPublisher()
        
        // execute
        state
            .canRefreshData(networkStatus: networkStatus)
            .sink { flag in
                XCTAssertFalse(flag)
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSortedByDateAscending() {
        
        // prepare
        let elements = [
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-20T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]()),
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-28T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]()),
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-27T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]())
        ]
        
        // execute
        let result = elements.sortedByDate(order: ComparisonResult.orderedAscending)
        
        XCTAssertNotNil(result[0].launchDateTime.asString, "2006-03-20T22:30:00.000Z")
        XCTAssertNotNil(result[1].launchDateTime.asString, "2006-03-27T22:30:00.000Z")
        XCTAssertNotNil(result[2].launchDateTime.asString, "2006-03-28T22:30:00.000Z")
    }
    
    func testSortedByDateDescending() {
        
        // prepare
        let elements = [
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-20T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]()),
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-28T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]()),
            LaunchModel(missionName: "", launchStatus: true, launchYear: "", launchDateTime: Date.from(string: "2006-03-27T22:30:00.000Z"), links: allNillLaunchModelLinks, properties: [LaunchModel.Property]())
        ]
        
        // execute
        let result = elements.sortedByDate(order: ComparisonResult.orderedDescending)
        
        XCTAssertNotNil(result[0].launchDateTime.asString, "2006-03-28T22:30:00.000Z")
        XCTAssertNotNil(result[1].launchDateTime.asString, "2006-03-27T22:30:00.000Z")
        XCTAssertNotNil(result[2].launchDateTime.asString, "2006-03-20T22:30:00.000Z")
    }
}
