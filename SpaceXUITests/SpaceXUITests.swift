//
//  SpaceXUITests.swift
//  SpaceXUITests
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import XCTest

class SpaceXUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func test() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-useMockProvider"]
        app.launch()
   
        // TODO: UI test recording
    }

}
