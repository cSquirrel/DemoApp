//
//  LaunchInfoTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import XCTest
@testable import SpaceX

class LaunchInfoTests: XCTestCase {
    
    func testCanDecodeFullDataSet() throws {

        // prepare
        let jsonData = try LoadJsonData(dataSet: .singleLaunch)
        
        // execute
        let result = try JSONDecoder().decode(LaunchInfo.self, from: jsonData)
        
        // verify
        XCTAssertEqual(result.flightNumber, 1)
        XCTAssertEqual(result.launchStatus, false)
        XCTAssertEqual(result.missionName, "FalconSat")
        XCTAssertEqual(result.rocketName, "Falcon 1")
        XCTAssertEqual(result.rocketType, "Merlin A")
        XCTAssertEqual(result.links.missionPatch?.absoluteString, "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")
        XCTAssertEqual(result.launchDateTime.asString(), "2006-03-24T22:30:00.000Z")
    }
    
    func testCanDecodeNullLaunchSuccess() throws {

        // prepare
        let jsonData = """
        {
            "flight_number": 1,
            "mission_name": "FalconSat",
            "launch_date_utc": "2006-03-24T22:30:00.000Z",
            "rocket": {
                "rocket_id": "falcon1",
                "rocket_name": "Falcon 1",
                "rocket_type": "Merlin A",
            },
            "launch_success": null,
            "links": {
                "mission_patch_small": "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
            }
        }
        """.data(using: .utf8)!
        
        // execute
        let result = try JSONDecoder().decode(LaunchInfo.self, from: jsonData)
        
        // verify
        XCTAssertEqual(result.launchStatus, false)
    }
}
