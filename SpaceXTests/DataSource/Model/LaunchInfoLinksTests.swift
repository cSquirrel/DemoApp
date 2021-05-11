//
//  LinksTests.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import XCTest
@testable import SpaceX

class LinksTests: XCTestCase {

    func testCanDecode() throws {

        // prepare
        let jsonData = """
        {
            "mission_patch_small": "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
            "article_link": "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html",
            "wikipedia": "https://en.wikipedia.org/wiki/DemoSat",
            "video_link": "https://www.youtube.com/watch?v=0a_00nJ_Y88"
        }
        """.data(using: .utf8)!
        
        // execute
        let result = try JSONDecoder().decode(LaunchInfo.Links.self, from: jsonData)
        
        // verify
        XCTAssertEqual(result.articleLink?.absoluteString, "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html")
        XCTAssertEqual(result.missionPatch?.absoluteString, "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")
        XCTAssertEqual(result.videolink?.absoluteString, "https://www.youtube.com/watch?v=0a_00nJ_Y88")
        XCTAssertEqual(result.wikipedia?.absoluteString, "https://en.wikipedia.org/wiki/DemoSat")
    }

    func testCanDecodeNullValue() throws {

        // prepare
        let jsonData = """
        {
            "mission_patch_small": null,
            "article_link": null,
            "wikipedia": null,
            "video_link": null
        }

        """.data(using: .utf8)!
        
        // execute
        let result = try JSONDecoder().decode(LaunchInfo.Links.self, from: jsonData)
        
        // verify
        XCTAssertNil(result.articleLink)
        XCTAssertNil(result.missionPatch)
        XCTAssertNil(result.videolink)
        XCTAssertNil(result.wikipedia)
    }
}
