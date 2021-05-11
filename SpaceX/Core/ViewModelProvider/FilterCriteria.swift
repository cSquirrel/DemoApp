//
//  FilterCriteria.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 07/05/2021.
//

import Foundation

protocol FilterCriteria {
    
    var year: String { get set }
    var status: Bool? { get set }
    
    func matches(_ launchData: LaunchModel) -> Bool
}

struct DefaultFilterCriteria {
    
    static let noFilter = DefaultFilterCriteria()
    
    var year: String = ""
    var status: Bool? = nil
    
}

extension DefaultFilterCriteria: FilterCriteria {
    
    func matches(_ launchData: LaunchModel) -> Bool {
        
        var result = true
        
        if !year.isEmpty {
            result = result && (launchData.launchYear == year)
        }
        
        if let status = status {
            result = result && (launchData.launchStatus == status)
        }
        
        return result
    }
}
