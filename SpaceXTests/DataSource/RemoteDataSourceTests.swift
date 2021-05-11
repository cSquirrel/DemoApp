//
//  RemoteDataSourceTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 10/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

class RemoteDataSourceTests: XCTestCase {

    var companyInfo: PassthroughSubject<(data: Data, response: URLResponse), URLError>!
    var allLaunches: PassthroughSubject<(data: Data, response: URLResponse), URLError>!
    var api: MockAPIConnector!
    let urlResponse = URLResponse(url: URL(string:"https://api.com/")!,
                                  mimeType: "application/json",
                                  expectedContentLength: 100,
                                  textEncodingName: "utf-8")
    var bag = Array<AnyCancellable>()
    
    struct MockAPIConnector: APIConnector {
        
        var companyInfo: AnyPublisher<(data: Data, response: URLResponse), URLError>
        var allLaunches: AnyPublisher<(data: Data, response: URLResponse), URLError>
        
        func fetchCompanyInfo(forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
            return companyInfo
        }
        
        func fetchAllLaunches(forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
            return allLaunches
        }
    }
    
    override func setUp() {
        companyInfo = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        allLaunches = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        api = MockAPIConnector(companyInfo: companyInfo.eraseToAnyPublisher(), allLaunches: allLaunches.eraseToAnyPublisher())
    }
    
    func testFetchAllLaunchesSuccessfull() throws {
        
        // prepare
        let data = try LoadJsonData(dataSet: .allLaunches)
        let expectation = expectation(description: "Received the value")
        let ds = RemoteDataSource(api: api)
        
        // execute
        ds
            .fetchAllLaunches()
            .sink { (completion: Subscribers.Completion<DataSourceError>) in
                // noop
            } receiveValue: { (value: [LaunchInfo]) in
                XCTAssertEqual(value.count, 111)
                expectation.fulfill()
            }
            .store(in: &bag)
        allLaunches.send((data: data, response: urlResponse))
        
        // verify
        wait(for: [expectation], timeout: 1.0)

    }

    func testFetchCompanyInfoSuccessfull() throws {
        
        // prepare
        let data = try LoadJsonData(dataSet: .companyInfo)
        let expectation = expectation(description: "Received the value")
        let ds = RemoteDataSource(api: api)
        
        // execute
        ds
            .fetchCompanyInfo()
            .sink { (completion: Subscribers.Completion<DataSourceError>) in
                // noop
            } receiveValue: { (value: CompanyInfo) in
                expectation.fulfill()
            }
            .store(in: &bag)
        companyInfo.send((data: data, response: urlResponse))
        
        // verify
        wait(for: [expectation], timeout: 1.0)

    }
}

class RemoteDataSourceOperatorsTests: XCTestCase {

    var publisher: PassthroughSubject<(data: Data, response: URLResponse), URLError>!
    var bag = Array<AnyCancellable>()
    
    override func setUp() {
        publisher = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
    }
    
    func testHandleResponseStatus200() throws {
        
        // prepare
        let expectation = expectation(description: "Received the value")
        let data = Data()
        let urlResponse = HTTPURLResponse(url: URL(string:"https://api.com/")!,
                                          statusCode: 200,
                                          httpVersion: "1.1",
                                          headerFields: nil)!
        // execute
        publisher
            .handleResponse()
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (value: Data) in
                expectation.fulfill()
            }
            .store(in: &bag)
        publisher.send((data: data, response: urlResponse))
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
 
    func testHandleResponseStatusNot200() throws {
        
        // prepare
        let expectation = expectation(description: "Received the error")
        let data = Data()
        let urlResponse = HTTPURLResponse(url: URL(string:"https://api.com/")!,
                                          statusCode: 300,
                                          httpVersion: "1.1",
                                          headerFields: nil)!
        // execute
        publisher
            .handleResponse()
            .sink { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let err):
                    XCTAssertEqual(err as? DataSourceError, DataSourceError.generalError)
                    expectation.fulfill()
                default:
                    XCTFail()
                }
            } receiveValue: { (value: Data) in
                XCTFail()
            }
            .store(in: &bag)
        publisher.send((data: data, response: urlResponse))
        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
}
