//
//  CombineOperatorTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 07/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

fileprivate struct MockData {
    
    static let linksModel = LaunchModel.Links(image: nil,
                                                  articleLink: nil,
                                                  wikipediaLink: nil,
                                                  videoLink: nil)
    static let launchInfoProperties = [
        LaunchModel.Property(label: "label", value: "value")
    ]
    static let launchInfoModel = LaunchModel(missionName: "Mission Name",
                                                 launchStatus: true,
                                                 launchYear: "2010",
                                                 launchDateTime: Date(),
                                                 links: linksModel,
                                                 properties:  launchInfoProperties)
    
    static let companyInfo = CompanyInfo(companyName: "ACME",
                                         founderName: "John Appleseed",
                                         year: 2020,
                                         employees: 12345,
                                         launchSites: 5,
                                         valuation: 150000)
    
    static let launchInfo = LaunchInfo(flightNumber: 1,
                                       missionName: "",
                                       launchDateTime: Date(),
                                       rocketName: "",
                                       rocketType: "",
                                       launchStatus: true,
                                       missionPatch: nil)
}

class CompanyInfoOperatorFormatInfoTests: XCTestCase {

    private var bag = Array<AnyCancellable>()
    
    func testFormat() throws {
        
        // prepare
        let expectation = expectation(description: "Format company info")
        let value = MockData.companyInfo
        let source = Just<CompanyInfo>(value)
            .setFailureType(to: DataSourceError.self)
            .eraseToAnyPublisher()
        
        // execute
        source
            .formatInfo()
            .sink { completion in
                // noop
            } receiveValue: { value in
                XCTAssertEqual(value, "ACME was founded by John Appleseed in 2020. It has now 12,345 employees, 5 launch sites, and is valued at USD 150,000")
                expectation.fulfill()
            }
            .store(in: &bag)

        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
}

class CompanyInfoOperatorMapToStateTests: XCTestCase {
    
    private var bag = Array<AnyCancellable>()
    
    func testMapLoadedToState() throws {
        
        // prepare
        let expectation = expectation(description: "Value is mapped")
        let value = "Lore Ipsum"
        let source = Just<String>(value)
            .setFailureType(to: DataSourceError.self)
            .eraseToAnyPublisher()
        
        // execute
        source
            .mapToState()
            .sink { completion in
                // noop
            } receiveValue: { state in
                switch state {
                case .loaded(value):
                    XCTAssertEqual(value, "Lore Ipsum")
                default:
                    XCTFail()
                }
                expectation.fulfill()
            }
            .store(in: &bag)

        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMapErrorToState() throws {
        
        // prepare
        let expectation = expectation(description: "Error is mapped")
        let source = Fail(outputType: String.self, failure: DataSourceError.generalError)
            .eraseToAnyPublisher()
        
        // execute
        source
            .mapToState()
            .sink { completion in
                // noop
            } receiveValue: { state in
                switch state {
                case .error(let err):
                    XCTAssertEqual(err, DataSourceError.generalError)
                default:
                    XCTFail()
                }
                expectation.fulfill()
            }
            .store(in: &bag)

        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
}

class LaunchInfoModelArrayOperatorMatching: XCTestCase {
    
    private var bag = Array<AnyCancellable>()
    
    struct MockFilterCriteria: FilterCriteria {
        
        var year: String = ""
        var status: Bool? = nil
        
        let matcher: (LaunchModel) -> Bool
        
        func matches(_ launchData: LaunchModel) -> Bool {
            return matcher(launchData)
        }
        
    }
    
    func testOnlyMatchingCallsFilter() throws {
        
        // prepare
        let expectation = expectation(description: "Filter is called")
        let value = [MockData.launchInfoModel]
        let source = Just<[LaunchModel]>(value)
            .setFailureType(to: DataSourceError.self)
            .eraseToAnyPublisher()
        
        // execute
        let criteria = MockFilterCriteria() { (LaunchInfoModel) -> Bool in
            expectation.fulfill()
            return true
        }
        source
            .onlyMatching(criteria: criteria)
            .sink { completion in
                // noop
            } receiveValue: { data in
                // noop
            }
            .store(in: &bag)

        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
}

class LaunchInfoModelArrayOperatorMapToStateTests: XCTestCase {
    
    private var bag = Array<AnyCancellable>()
    
    func testMapLoadedToState() throws {
        
        // prepare
        let expectation = expectation(description: "Filter is called")
        let value = [MockData.launchInfoModel]
        let source = Just<[LaunchModel]>(value)
            .setFailureType(to: DataSourceError.self)
            .eraseToAnyPublisher()
        
        // execute
        source
            .mapToState()
            .sink { completion in
                // noop
            } receiveValue: { state in
                switch state {
                case .loaded(let value):
                    XCTAssertEqual(value.count, 1)
                default:
                    XCTFail()
                }
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMapErrorToState() throws {
        
        // prepare
        let expectation = expectation(description: "Filter is called")
        let source = Fail(outputType: [LaunchModel].self, failure: DataSourceError.generalError).eraseToAnyPublisher()
        
        // execute
        source
            .mapToState()
            .sink { completion in
                // noop
            } receiveValue: { state in
                switch state {
                case .error(let err):
                    XCTAssertEqual(err, DataSourceError.generalError)
                default:
                    XCTFail()
                }
                expectation.fulfill()
            }
            .store(in: &bag)
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
}

class LaunchInfoArrayOperatorMaptoModelTests: XCTestCase {
    
    private var bag = Array<AnyCancellable>()
    
    func testMapToModel() throws {
        
        // prepare
        let expectation = expectation(description: "Filter is called")
        let value = [MockData.launchInfo]
        let source = Just<[LaunchInfo]>(value)
            .setFailureType(to: DataSourceError.self)
            .eraseToAnyPublisher()
        
        // execute
        source
            .mapToModel()
            .sink { completion in
                // noop
            } receiveValue: { launchInfoModel in
                XCTAssertNotNil(launchInfoModel.first)
                expectation.fulfill()
            }
            .store(in: &bag)

        // verify
        wait(for: [expectation], timeout: 1.0)
    }
}
