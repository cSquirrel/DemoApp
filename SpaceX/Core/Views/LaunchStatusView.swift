//
//  LaunchStatusView.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import SwiftUI


struct LaunchStatusView: View {
    
    let launchStatus: Bool
    
    var imageName: String {
        if launchStatus {
            return "checkmark.square.fill"
        } else {
            return "multiply.square"
        }
    }
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .frame(width: Style.missionStatusSize.width, height: Style.missionStatusSize.height, alignment: .top)
    }
}

struct LaunchStatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LaunchStatusView(launchStatus: true)
            LaunchStatusView(launchStatus: false)
        }
    }
}
