//
//  LaunchModelCreator.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import Foundation

struct LaunchModelCreator {
    
    let formatter: Localisation
    
    init(referenceDate rd: Date = Date(), locale l: Locale = Locale.current) {
        formatter = Localisation(referenceDate: rd, locale: l)
    }
    
    func createCompanyInfo(_ companyInfo: CompanyInfo) -> String {
        let result = formatter.formatCompanyInfo(companyInfo)
        return result
    }
    
    func createPropertiesFrom(launchInfo: LaunchInfo) -> [LaunchModel.Property] {
                
        let properties = [
            formatter.formatMissionName(launchInfo: launchInfo),
            formatter.formatLaunchDateTime(launchInfo: launchInfo),
            formatter.formatRocketInfo(launchInfo: launchInfo),
            formatter.formatDaysInterval(launchInfo: launchInfo)
        ]
        
        return properties
    }
    
    func createLinksFrom(launchInfo: LaunchInfo) -> LaunchModel.Links {
        
        let links = LaunchModel.Links(image: launchInfo.links.missionPatch,
                                          articleLink: launchInfo.links.articleLink,
                                          wikipediaLink: launchInfo.links.wikipedia,
                                          videoLink: launchInfo.links.videolink)
        return links
    }
    
    func createModelFrom(launchInfo: LaunchInfo) -> LaunchModel {
        
        let year = formatter.formatLaunchYear(launchInfo: launchInfo)
        let links = createLinksFrom(launchInfo: launchInfo)
        let properties = createPropertiesFrom(launchInfo: launchInfo)
        
        let result = LaunchModel(missionName: launchInfo.missionName,
                                     launchStatus: launchInfo.launchStatus,
                                     launchYear: year,
                                     launchDateTime: launchInfo.launchDateTime,
                                     links: links,
                                     properties: properties)
        return result
    }
    
    func createModelsFrom(launchInfo: [LaunchInfo]) -> [LaunchModel] {
        let result = launchInfo.map { self.createModelFrom(launchInfo: $0) }
        return result
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
