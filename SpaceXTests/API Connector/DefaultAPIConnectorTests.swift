//
//  DefaultAPIConnectorTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

class DefaultAPIConnectorTests: XCTestCase {

    private var bag = Array<AnyCancellable>()
    let configuration = APIConnectorConfiguration(companyInfoEndpoint: URL(string: "https://api.com/companyInfo")!,
                                                  allLaunchesEndpoint: URL(string: "https://api.com/allLaunches")!)
    
    struct MockURLFetcher: UrlFetcher {
        
        var mockData = Data()
        var mockResponse: URLResponse?
        
        func fetch(url: URL, forceReload: Bool) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
            
            let response: URLResponse
            if let mockResponse = mockResponse {
                response = mockResponse
            } else {
                response = URLResponse(url: url,
                                           mimeType: "text/plain",
                                           expectedContentLength: 0,
                                           textEncodingName: "utf-8")
            }
            
            return Just((mockData, response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
    }
    
    func testFetchAllLaunchesCallsUrlFetcher() throws {
        
        // prepare
        let expectation = expectation(description: "Called URL fetcher")
        let mockData = Data()
        let urlFetcher = MockURLFetcher(mockData: mockData, mockResponse: nil)
        let connector = DefaultAPIConnector(configuration: configuration, urlFetcher: urlFetcher)
        
        // execute
        connector
            .fetchAllLaunches()
            .sink { completion in
                // noop
            } receiveValue: { (data: Data, response: URLResponse) in
                XCTAssertEqual(response.url?.absoluteString, "https://api.com/allLaunches")
                expectation.fulfill()
            }
            .store(in: &bag)

        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchCompanyInfoCallsUrlFetcher() throws {
        
        // prepare
        let expectation = expectation(description: "Called URL fetcher")
        let mockData = Data()
        let urlFetcher = MockURLFetcher(mockData: mockData, mockResponse: nil)
        let connector = DefaultAPIConnector(configuration: configuration, urlFetcher: urlFetcher)
        
        // execute
        connector
            .fetchCompanyInfo()
            .sink { completion in
                // noop
            } receiveValue: { (data: Data, response: URLResponse) in
                XCTAssertEqual(response.url?.absoluteString, "https://api.com/companyInfo")
                expectation.fulfill()
            }
            .store(in: &bag)

        
        // verify
        wait(for: [expectation], timeout: 1.0)
    }
}
