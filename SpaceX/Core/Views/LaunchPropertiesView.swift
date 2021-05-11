//
//  LaunchPropertiesView.swift
//  SpaceX
//
//  Created by Marcin Maciukiewicz on 09/05/2021.
//

import SwiftUI

struct LaunchPropertiesView: View {
    
    let properties: [LaunchModel.Property]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(properties, id: \.label) { property in
                    Text(property.label)
                        .font(.caption)
                }
            }
            VStack(alignment: .leading) {
                ForEach(properties, id: \.label) { property in
                    Text(property.value)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct LaunchPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchPropertiesView(properties: [
            LaunchModel.Property(label: "Mission:", value: "Starlink-14 (v1.0)"),
            LaunchModel.Property(label: "Date/Time:", value: "Oct 24, 2020 at 4:31 PM"),
            LaunchModel.Property(label: "Rocket:", value: "Falcon 9 / FT"),
            LaunchModel.Property(label: "Days since now:", value: "-197"),
           ])
        .padding()
        .border(Color.black)
    }
}
