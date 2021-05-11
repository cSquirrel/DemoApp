//
//  LaunchInfo.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation

struct LaunchInfo: Decodable {
    
    let flightNumber: Int
    let missionName: String
    let launchDateTime: Date
    let rocketName: String
    let rocketType: String
    let launchStatus: Bool
    let links: Links
    
    struct Links: Decodable {
        
        let missionPatch: URL?
        let articleLink: URL?
        let wikipedia: URL?
        let videolink: URL?
        
        enum CodingKeys: String, CodingKey {
            case missionPatch = "mission_patch_small"
            case articleLink = "article_link"
            case wikipedia = "wikipedia"
            case videolink = "video_link"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case missionName = "mission_name"
        case launchDateTime = "launch_date_utc"
        case rocket
        case links
        case launchStatus = "launch_success"
    }
    
    enum RocketKeys: String, CodingKey {
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flightNumber = try values.decode(Int.self, forKey: .flightNumber)
        missionName = try values.decode(String.self, forKey: .missionName)
        
        if let status = try? values.decode(Bool.self, forKey: .launchStatus) {
            launchStatus = status
        } else {
            launchStatus = false
        }
        
        let launchDateTimeString = try values.decode(String.self, forKey: .launchDateTime)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        launchDateTime = formatter.date(from: launchDateTimeString) ?? Date()
        
        let rocket = try values.nestedContainer(keyedBy: RocketKeys.self, forKey: .rocket)
        rocketName = try rocket.decode(String.self, forKey: .rocketName)
        rocketType = try rocket.decode(String.self, forKey: .rocketType)
        
//        let links = try values.nestedContainer(keyedBy: LinksKeys.self, forKey: .links)
//        if let missionPatchString = try? links.decode(String.self, forKey: .missionPatch) {
//            missionPatch = URL(string: missionPatchString)
//        } else {
//            missionPatch = nil
//        }
        
        links = try values.decode(Links.self, forKey: .links)
    }
    
    init(flightNumber: Int,
         missionName: String,
         launchDateTime: Date,
         rocketName: String,
         rocketType: String,
         launchStatus: Bool,
         missionPatch: URL?) {
        
        self.flightNumber = flightNumber
        self.missionName = missionName
        self.launchDateTime = launchDateTime
        self.rocketName = rocketName
        self.rocketType = rocketType
        self.launchStatus = launchStatus
        
        self.links = Links(missionPatch: missionPatch,
                           articleLink: nil,
                           wikipedia: nil,
                           videolink: nil)
    }
}


