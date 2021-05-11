//
//  MockData.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import Foundation
@testable import SpaceX

private class BundleProvider {}

enum MockDataSet: String {
    case companyInfo = "CompanyInfo.json"
    case allLaunches = "AllLaunches.json"
    case manyLaunches = "ManyLaunches.json"
    case singleLaunch = "SingleLaunch.json"
}

func LoadJsonData(dataSet: MockDataSet) throws -> Data {
    let bundle = Bundle(for: BundleProvider.self)
    let contentUrl = bundle.url(forResource: dataSet.rawValue, withExtension: nil)!
    let result = try Data(contentsOf: contentUrl)
    return result
}


let allNillLaunchModelLinks = LaunchModel.Links(image: nil, articleLink: nil, wikipediaLink: nil, videoLink: nil)

