//
//  CompanyInfo.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation

struct CompanyInfo: Decodable {
    
    let companyName: String
    let founderName: String
    let year: Int
    let employees: Int
    let launchSites: Int
    let valuation: Int
    
    enum CodingKeys: String, CodingKey {
        case companyName = "name"
        case founderName = "founder"
        case year = "founded"
        case employees
        case launchSites = "launch_sites"
        case valuation
    }
    
}
