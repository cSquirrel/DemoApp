//
//  LaunchModelCreatorTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import XCTest
@testable import SpaceX

class LaunchModelCreatorTests: XCTestCase {
    
    private var creator: LaunchModelCreator!
    private var launchInfo:[LaunchInfo] {
        let jsonData = try? LoadJsonData(dataSet: .allLaunches)
        return try! JSONDecoder().decode([LaunchInfo].self, from: jsonData!)
    }
    
    override func setUp() {
        let referenceDate = Date.from(string: "2006-03-26T22:30:00.000Z")
        let locale = Locale(identifier: "en_GB")
        creator = LaunchModelCreator(referenceDate: referenceDate, locale: locale)
    }
    
    func testCreateModels() throws {
        
        // execute
        let result = creator.createModelsFrom(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result.count, 111)
    }
    
    func testCreateModel() throws {
        
        // execute
        let result = creator.createModelsFrom(launchInfo: launchInfo)
        
        // validate
        let firstLaunch = result.first!
        XCTAssertEqual(firstLaunch.launchStatus, false)
        XCTAssertEqual(firstLaunch.links.image?.absoluteString, "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")
        
        XCTAssertEqual(firstLaunch.launchYear, "2006")
        XCTAssertEqual(firstLaunch.launchDateTime.asString(), "2006-03-24T22:30:00.000Z")
        
        let properties = firstLaunch.properties
        XCTAssertEqual(properties.count, 4)
        XCTAssertEqual(properties[0].label, "Mission:")
        XCTAssertEqual(properties[1].label, "Date/Time:")
        XCTAssertEqual(properties[2].label, "Rocket:")
        XCTAssertEqual(properties[3].label, "Days since:")

    }
}
