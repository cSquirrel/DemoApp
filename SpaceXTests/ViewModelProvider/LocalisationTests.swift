//
//  CompanyInfoFormatterTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import XCTest
import Combine
@testable import SpaceX

class LocalisationTests: XCTestCase {
    
    private var launchInfo:LaunchInfo {
        let jsonData = try? LoadJsonData(dataSet: .singleLaunch)
        return try! JSONDecoder().decode(LaunchInfo.self, from: jsonData!)
    }
    
    func testFormatCompanyInfo() {
        
        let formatter = Localisation()
        let companyInfo = CompanyInfo(companyName: "Company Name",
                                      founderName: "Founder Name",
                                      year: 2020,
                                      employees: 6723,
                                      launchSites: 5987,
                                      valuation: 12000000)
        
        // execute
        let result = formatter.formatCompanyInfo(companyInfo)
        
        // validate
        XCTAssertEqual(result, "Company Name was founded by Founder Name in 2020. It has now 6,723 employees, 5,987 launch sites, and is valued at USD 12,000,000")
    }
    
    func testCreateModelMissionName() throws {
        
        let formatter = Localisation()
        
        // execute
        let result = formatter.formatMissionName(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result, LaunchModel.Property(label: "Mission:", value: "FalconSat"))
    }

    func testCreateModelDateTime() throws {
        
        let locale = Locale(identifier: "en_GB")
        let formatter = Localisation(locale: locale)
        
        // execute
        let result = formatter.formatLaunchDateTime(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result, LaunchModel.Property(label: "Date/Time:", value: "24 Mar 2006 at 22:30"))
    }
    
    func testCreateModelRocketName() throws {
        
        let formatter = Localisation()
        
        // execute
        let result = formatter.formatRocketInfo(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result, LaunchModel.Property(label: "Rocket:", value: "Falcon 1 / Merlin A"))
    }
    
    func testCreateModelDaysFrom() throws {
        
        // prepare
        let referenceDate = Date.from(string: "2006-03-20T22:30:00.000Z")
        let formatter = Localisation(referenceDate: referenceDate)
        
        // execute
        let result = formatter.formatDaysInterval(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result, LaunchModel.Property(label: "Days from:", value: "4"))
    }
    
    func testCreateModelDaysSince() throws {
        
        // prepare
        let referenceDate = Date.from(string: "2006-03-26T22:30:00.000Z")
        let formatter = Localisation(referenceDate: referenceDate)
        
        // execute
        let result = formatter.formatDaysInterval(launchInfo: launchInfo)
        
        // validate
        XCTAssertEqual(result, LaunchModel.Property(label: "Days since:", value: "-2"))
    }
}
