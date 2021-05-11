//
//  LaunchInfoList.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import SwiftUI

struct LaunchModelView: View {
    
    @EnvironmentObject var imageManager: RemoteImageManager
    
    let model: LaunchModel
    
    var body: some View {
        HStack(alignment: .top) {
            
            RemoteImage(loader: imageManager.fetchImage(url: model.links.image))
                .foregroundColor(.gray)
                .frame(width: Style.missionPatchSize.width, height: Style.missionPatchSize.height, alignment: .top)
            
            LaunchPropertiesView(properties: model.properties)
                .frame(maxWidth: .infinity)
            
            LaunchStatusView(launchStatus: model.launchStatus)
            
        }
        .frame(maxWidth: .infinity)
    }
}

struct LaunchModelView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchModelView(model: LaunchModel(missionName: "Test Mission",
                                           launchStatus: true,
                                           launchYear: "2020",
                                           launchDateTime: Date(),
                                           links: LaunchModel.Links(image: nil,
                                                                    articleLink: nil,
                                                                    wikipediaLink: nil,
                                                                    videoLink: nil),
                                           properties: [
                                            LaunchModel.Property(label: "Mission:", value: "Starlink-14 (v1.0)"),
                                            LaunchModel.Property(label: "Date/Time:", value: "Oct 24, 2020 at 4:31 PM"),
                                            LaunchModel.Property(label: "Rocket:", value: "Falcon 9 / FT"),
                                            LaunchModel.Property(label: "Days since now:", value: "-197"),
                                           ]))
    }
}
