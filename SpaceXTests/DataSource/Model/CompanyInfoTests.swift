//
//  CompanyInfoTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import XCTest
@testable import SpaceX

class CompanyInfoTests: XCTestCase {

    func testCanDecode() throws {

        // prepare
        let jsonData = try LoadJsonData(dataSet: .companyInfo)
        
        // execute
        let result = try JSONDecoder().decode(CompanyInfo.self, from: jsonData)
        
        // verify
        XCTAssertEqual(result.companyName, "ACME")
        XCTAssertEqual(result.founderName, "John Appleseed")
        XCTAssertEqual(result.employees, 23)
        XCTAssertEqual(result.launchSites, 67)
        XCTAssertEqual(result.valuation, 23000000000)
        XCTAssertEqual(result.year, 1977)
    }

}
