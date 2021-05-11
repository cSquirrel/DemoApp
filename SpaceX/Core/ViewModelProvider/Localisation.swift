//
//  CompanyInfoFormatter.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import Foundation

struct Localisation {
    
    private let numberFormatter: NumberFormatter
    private let referenceDate: Date
    private let locale: Locale
    
    private var dateFormatter: DateFormatter
    private var timeFormatter: DateFormatter
    private let calendar: Calendar
    
    init(referenceDate rd: Date = Date(), locale l: Locale = Locale.current) {
        numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        referenceDate = rd
        locale = l
        
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateStyle = .medium
        dateOnlyFormatter.timeStyle = .none
        dateOnlyFormatter.locale = locale
        dateFormatter = dateOnlyFormatter
        
        let timeOnlyFormatter = DateFormatter()
        timeOnlyFormatter.dateStyle = .none
        timeOnlyFormatter.timeStyle = .short
        timeOnlyFormatter.locale = locale
        timeFormatter = timeOnlyFormatter
        
        calendar = locale.calendar
    }
    
    func formatCompanyInfo(_ companyInfo: CompanyInfo) -> String {
        
        let formattedEmployees = numberFormatter.string(from: companyInfo.employees as NSNumber) ?? String(companyInfo.employees)
        let formattedValuation = numberFormatter.string(from: companyInfo.valuation as NSNumber) ?? String(companyInfo.valuation)
        let formattedLaunchSites = numberFormatter.string(from: companyInfo.launchSites as NSNumber) ?? String(companyInfo.launchSites)
            
        return "\(companyInfo.companyName) was founded by \(companyInfo.founderName) in \(companyInfo.year). It has now \(formattedEmployees) employees, \(formattedLaunchSites) launch sites, and is valued at USD \(formattedValuation)"
    }
    
    func formatMissionName(launchInfo: LaunchInfo) -> LaunchModel.Property {
        return LaunchModel.Property(label: "Mission:", value: "\(launchInfo.missionName)")
    }
    
    func formatLaunchDateTime(launchInfo: LaunchInfo) -> LaunchModel.Property {
        let launchDate = dateFormatter.string(from: launchInfo.launchDateTime)
        let launchTime = timeFormatter.string(from: launchInfo.launchDateTime)
        return LaunchModel.Property(label: "Date/Time:", value: "\(launchDate) at \(launchTime)")
    }
    
    func formatRocketInfo(launchInfo: LaunchInfo) -> LaunchModel.Property {
        LaunchModel.Property(label: "Rocket:", value: "\(launchInfo.rocketName) / \(launchInfo.rocketType)")
    }
    
    func formatDaysInterval(launchInfo: LaunchInfo) -> LaunchModel.Property {
        
        let result:LaunchModel.Property
        
        let interval = calendar.numberOfDaysBetween(referenceDate, and:launchInfo.launchDateTime )
        let inThePast = interval > 0
        if inThePast {
            result = LaunchModel.Property(label: "Days from:", value: "\(interval)")
        } else {
            result = LaunchModel.Property(label: "Days since:", value: "\(interval)")
        }
        
        return result
    }

    func formatLaunchYear(launchInfo: LaunchInfo) -> String {
        let result = calendar.dateComponents([.year], from: launchInfo.launchDateTime).year ?? 0
        return String(result)
    }
}
