//
//  LaunchInfoList.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 05/05/2021.
//

import SwiftUI

struct AllLaunchModelsView: View {
    
    @Binding var selectedLaunch: LaunchModel?
    let model: [LaunchModel]
    
    var body: some View {
        ForEach(model) { data in
            Button {
                selectedLaunch = data
            } label: {
                LaunchModelView(model: data)
            }
            .foregroundColor(.primary)
            .buttonStyle(BorderlessButtonStyle())
        }
        .frame(maxWidth: .infinity)
    }
}

struct AllLaunchModelsView_Previews: PreviewProvider {
    
    static let model = LaunchModel(missionName: "Test Mission",
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
                                           ])
    
    @State static var selectedLaunch: LaunchModel?
    
    static var previews: some View {
        AllLaunchModelsView(selectedLaunch: $selectedLaunch, model: [model, model, model, model])
    }
}
