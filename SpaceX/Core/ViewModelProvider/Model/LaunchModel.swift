//
//  LaunchInfoModel.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation

struct LaunchModel: Identifiable {
    
    struct Links: Decodable {
        let image: URL?
        let articleLink: URL?
        let wikipediaLink: URL?
        let videoLink: URL?
    }
    
    struct Property {
        let label: String
        let value: String
    }
    
    let id = UUID()
    let missionName: String
    let launchStatus: Bool
    let launchYear: String
    let launchDateTime: Date
    let links: Links
    let properties: [Property]
    
}
